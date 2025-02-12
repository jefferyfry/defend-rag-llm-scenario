variable "vm_count" {
  description = "Count of Instances to deploy"
  type        = string
  default     = "1"
}

variable "ami" {
  description = "The ID of AMI"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "User Data used to configure the instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Defines the instance type"
  type        = string
  default     = "t2.medium"
}

variable "iam_instance_profile" {
  description = "Defines the instance profile"
  type        = string
  default     = "webserver_role"
}

variable "subnet_id" {
  description = "The ID of subnet where to deploy instance"
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Should be true if you want to have public IP address on your instance"
  type        = string
  default     = "true"
}

variable "vpc_security_group_ids" {
  description = "List of IDs for security groups"
  type        = list
  default     = []
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "Should be true if you want to activate monitoring"
  type        = string
  default     = "false"
}

variable "root_block_device" {
  description = "Lists of root devices"
  type        = list(map(string))

  default = [
    {
      delete_on_termination = "true"
      volume_size           = "50"
    },
  ]
}

variable "ebs_block_device" {
  description = "List of ebs block devices"
  type        = list(map(string))

  default = [
    {
      delete_on_termination = "true"
      device_name           = "sdf"
      snapshot_id           = ""
      volume_type           = "io1"
      volume_size           = "50"
      iops                  = 100
      encrypted             = false
      kms_key_id            = ""
    },
  ]
}

variable "tags" {
  description = "Default tags used by any resources"
  type        = map

  default = {
    "owner"       = "nehrman"
    "purpose"     = "CTF"
    "environment" = "production"
  }
}

variable "instance_tags" {
  description = "Specific tags used by instances"
  type        = map

  default = {
    "Name" = "WIZ CTF"
  }
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
  description = "IP of vector db server"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "region" {
  description = "Name of the AWS region"
  type        = string
}

variable "role_name" {
  description = "Name of the ec2 role"
  type        = string
}