import json
import logging
import os
import random
import string
import sys

import chromadb
from llama_index.core import (Settings, VectorStoreIndex, SimpleDirectoryReader, PromptTemplate)
from llama_index.core import StorageContext
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.llms.ollama import Ollama
from llama_index.vector_stores.chroma import ChromaVectorStore
from llama_index.core.schema import TextNode
from s3fs import S3FileSystem

from flask import Flask
from flask import jsonify
from flask import request
from flask_cors import CORS

logging.basicConfig(stream=sys.stdout, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = Flask(__name__)
CORS(app)

global query_engine
query_engine = None

def init_llm():
    llm = Ollama(model="llama3.2", request_timeout=300.0)
    embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-small-en-v1.5")
    Settings.llm = llm
    Settings.embed_model = embed_model

def init_index():
    s3files = S3FileSystem(anon=False)
    data = SimpleDirectoryReader(os.getenv("bucket_name"), fs=s3files, recursive=True)
    docs = data.load_data()
    return VectorStoreIndex.from_documents(docs)


def init_query_engine(vector_index):
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

    return query_engine

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
    init_llm()
    index = init_index()
    init_query_engine(index)

    print("Starting server...")
    app.run(host='0.0.0.0', port=8080, debug=True)
    print("Done...")