output "ragserver_ip" {
  value = module.aws_rag_instance.instance_public_ip
}

output "dev_instance_role_arn" {
  value = aws_iam_role.instance_connect_role.arn
}

output "ragserver_instance_id" {
  value = module.aws_rag_instance.instance_id
}

output "s3_bucket_name" {
  value = module.sensitive_bucket.bucket_name
}