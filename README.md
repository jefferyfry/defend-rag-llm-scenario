# Defend RAG LLM Scenario

## Overview
This repository contains the Terraform code to deploy a RAG LLM scenario that demonstrates the security capabilities of the Wiz platform.
The scenario deploys a vulnerable RAG LLM Application that is a cybersecurity chat app. Users can send cybersecurity questions to the app and get answers.

## How the RAG LLM App Works

![RAG LLM Scenario](https://raw.githubusercontent.com/jefferyfry/defend-rag-llm-scenario/refs/heads/main/images/rag-llm-app.png)

On initial deployment, the RAG LLM app processes several cybersecurity documents in an S3 bucket by chunking and then storing the chunks into a Chroma vector database using HuggingFace embedding model.
Then users can send a post request to a RAG LLM app to get answers to their questions.

For example, a user can send a POST request to the app with the following JSON payload:
```
curl -i -XPOST "http://<rag server IP>:8080/api/question" \
    --header "Content-Type: application/json" \
    --data '{
        "question": "What is cloud security?",
        "user_id": "me"
    }'
```

When this request is received the questions are vectorized by the app and the closest results are extracted from the Chroma vector database. 
Llama3.2 via Ollama is used as the language model to generate the answers from the results. This is all managed by the LlamaIndex framework.

## Deploying the Scenario

### Deploying the Vulnerable RAG LLM Infrastructure

#### Note
The RAG LLM instance should be deployed using a g4dn.xlarge instance type in order to provide the necessary GPU resources for the LLM model.
A non-GPU instance type can be used, but the LLM model will take significantly longer to process requests and will likely timeout.
For the purposes of this scenario and deploying vulnerable infrastructure a non-GPU instance type can be used. Change the instance type in the following file to use a non-GPU instance type.

Vulnerable_infra/main.tf:
```
module "aws_rag_instance" {
  source                  = "./modules/terraform-aws-rag-instance"
  .
  .
  .
  instance_type           = "g4dn.xlarge"
```

#### Environment Variables
Ensure the following environment variables are set.

| Environment Variable           | Description                                                                              |
|--------------------------------|------------------------------------------------------------------------------------------|
| AWS_ACCESS_KEY_ID              | Your AWS credentials for terraform deployment only. eg. AKIAQEFWAZ...                    |
| AWS_SECRET_ACCESS_KEY          | Your AWS credentials for terraform deployment only. eg. vjrQ/g/...                       |
| AWS_DEFAULT_REGION             | Your AWS region for terraform deployment only. eg. us-east-2                             |
| TF_VAR_aws_key_pair_public_key | The SSH public key to install on servers. eg. ssh-rsa AAAAB3NzaC1yc2...                  |
| TF_VAR_client_id               | The Wiz sensor client ID to be used for sensor install on servers. eg. t3zxg...          |
| TF_VAR_client_secret           | The Wiz sensor client secret to be used for sensor install on servers. eg. Jdy1YH...     |
| TF_VAR_vpc_azs                 | The VPC availability zones to configure. eg.  ["us-east-2a", "us-east-2b", "us-east-2c"] |

#### Terraform

1. change directory to the Vulnerable_infra directory
2. execute terraform plan -out tfplan
2. execute terraform apply tfplan

Note: 'terraform apply' will take approximately 30 minutes due to deploying the RAG LLM instance.
The language model download and document processing will take the most time.

### Deploying the Attack Infrastructure

**TBD**

