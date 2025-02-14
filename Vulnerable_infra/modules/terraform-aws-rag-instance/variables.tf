variable "prefix" {
  description = "Prefix for resource names" 
  type        = string
}

variable "suffix" {
  description = "Suffix for resource names" 
  type        = string
}

variable "owner" {
  description = "Owner of resource" 
  type        = string
}

variable "environment" {
  description = "Environement where resources are deployed" 
  type        = string
}

variable "ttl" {
  description = "TTL of the Game platform" 
  type        = string
  default     = "24h"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  default     = ""
}

variable "vpc_public_subnets" {
  description = "List of IDs of public subnets"
  type        = list
  default     = []
}

variable "vpc_private_subnets" {
  description = "List of IDs of private subnets"
  type        = list
  default     = []
}
variable "tags" {
  description = "Tags for resources"
  type        = map
  default     = {}
}

variable "instance_type" {
  description = "Define the instance type"
  type        = string
  default     = "t2.medium"
}

variable "iam_instance_profile" {
  description = "Define the instance profiletype"
  type        = string
  default     = "webserver_role"
}

variable "client_id" {
  description = "Wiz Client ID for Sensor"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Wiz Client Secret for Sensor"
  type        = string
  sensitive   = true
}

variable "vectordb_ip" {
  description = "IP of the vector db server"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "region" {
  description = "Name of AWS region"
  type        = string
}

variable "role_name" {
  description = "Name of the rag server EC2 role"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = ""
}