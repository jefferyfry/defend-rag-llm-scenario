output "sg_id" {
  description = "The IDs of Security Group"
  value       = module.aws_sg_ragserver.sg_id
}

output "instance_arn" {
  description = "The IDs of the instance"
  value       = module.aws_instance_ragserver.instance_arn
}

output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = module.aws_instance_ragserver.instance_public_ip
}

output "instance_id" {
  description = "The ID of the instance"
  value       = module.aws_instance_ragserver.instance_id
  
}



