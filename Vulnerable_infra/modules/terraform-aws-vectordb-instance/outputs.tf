output "sg_id" {
  description = "The IDs of Security Group"
  value       = module.aws_sg_vectordbserver.sg_id
}

output "instance_arn" {
  description = "The IDs of the instance"
  value       = module.aws_instance_vectordbserver.instance_arn
}

output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = module.aws_instance_vectordbserver.instance_public_ip
}

output "instance_private_ip" {
  description = "The private IP of the instance"
  value       = module.aws_instance_vectordbserver.instance_private_ip
}

output "instance_id" {
  description = "The ID of the instance"
  value       = module.aws_instance_vectordbserver.instance_id
  
}



