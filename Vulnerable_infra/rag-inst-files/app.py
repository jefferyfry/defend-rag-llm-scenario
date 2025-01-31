import logging
import sys

import chromadb
from chromadb import DEFAULT_TENANT, DEFAULT_DATABASE
from flask import Flask
from flask import jsonify
from flask import request
from flask_cors import CORS
from llama_index.core import (Settings, VectorStoreIndex, SimpleDirectoryReader, PromptTemplate)
from llama_index.core import StorageContext
from llama_index.core.node_parser import SentenceSplitter
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.llms.ollama import Ollama
from llama_index.vector_stores.chroma import ChromaVectorStore
from s3fs import S3FileSystem

logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = Flask(__name__)
CORS(app)

KNOWLEDGE_BASE = "cybersecurity_knowledge_base"

global query_engine
query_engine = None

def get_index(vectordb_ip:str, bucket_name:str):
    llm = Ollama(model="llama3.2", request_timeout=300.0)
    embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-small-en-v1.5")
    Settings.llm = llm
    Settings.embed_model = embed_model

    print(f"Connecting to vector database at {vectordb_ip}")
    client = chromadb.HttpClient(
        host=vectordb_ip,
        port=8000,
        ssl=False,
        tenant=DEFAULT_TENANT,
        database=DEFAULT_DATABASE,
    )
    try:
        chroma_collection = client.get_collection(KNOWLEDGE_BASE)
        logging.info(f"Collection {KNOWLEDGE_BASE} exists.")
        vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
        storage_context = StorageContext.from_defaults(vector_store=vector_store)

        return VectorStoreIndex(storage_context=storage_context, embed_model=embed_model)
    except:
        logging.info(f"Collection {KNOWLEDGE_BASE} does not exist. Creating a new one from bucket {bucket_name}...")
        s3files = S3FileSystem(anon=False,iam_role="auto")
        data = SimpleDirectoryReader(input_dir=bucket_name, fs=s3files, recursive=True)
        docs = data.load_data()
        parser = SentenceSplitter()
        nodes = parser.get_nodes_from_documents(docs)
        chroma_collection = client.create_collection(KNOWLEDGE_BASE)

        vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
        storage_context = StorageContext.from_defaults(vector_store=vector_store)

        return VectorStoreIndex(nodes, storage_context=storage_context, embed_model=embed_model)

def start_query_engine(vector_index):
    global query_engine

    template = (
        "You are a cybersecurity expert."
        "\n---------------------\n"
        "{context_str}"
        "\n---------------------\n"
        "Given this information, please answer the question: {query_str}\n"
    )
    qa_template = PromptTemplate(template)

    query_engine = vector_index.as_query_engine(text_qa_template=qa_template, similarity_top_k=5)

def chat(input_question):
    global query_engine

    response = query_engine.query(input_question)
    logging.info("got response from llm - %s", response)

    return response.response

@app.route('/api/question', methods=['POST'])
def post_question():
    json_req = request.get_json(silent=True)
    question = json_req['question']
    logging.info("post question `%s` for user `%s`", question, json_req)

    resp = chat(question)
    data = {'answer':resp}

    return jsonify(data), 200

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python app.py <vectordb_ip> <bucket_name>")
        sys.exit(1)

    vectordb_ip = sys.argv[1]
    bucket_name = sys.argv[2]
    index = get_index(vectordb_ip, bucket_name)
    start_query_engine(index)

    print("Starting server...")
    app.run(host='0.0.0.0', port=8080, debug=True)
    print("Done...")