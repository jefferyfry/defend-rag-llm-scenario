output "ragserver_ip" {
  value = module.aws_rag_instance.instance_public_ip
}

output "ragserver_instance_id" {
  value = module.aws_rag_instance.instance_id
}

output "vectordbserver_ip" {
  value = module.aws_vectordb_instance.instance_public_ip
}

output "vectordbserver_instance_id" {
  value = module.aws_vectordb_instance.instance_id
}

output "s3_bucket_name" {
  value = module.sensitive_bucket.bucket_name
}