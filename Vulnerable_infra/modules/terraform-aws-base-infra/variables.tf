variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "wiz-ctf-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = list
  default     = ["10.0.1.0/24"]
}

variable "vpc_private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list
  default     = ["10.0.10.0/24"]
}

variable "vpc_azs" {
  description = "List of Availability Zones to use for the subnets in the VPC"
  type        = list(string)
  default     = ["us-east-1a"]
}

variable "vpc_internet_gateway" {
  description = "Create an Internet Gateway for the VPC"
  type        = string
  default     = "true"
}

variable "vpc_single_nat_gateway" {
  description = "Create a single NAT Gateway for the VPC"
  type        = string
  default     = "false"
}

variable "vpc_nat_gateway_per_az" {
  description = "Create a NAT Gateway for each Availability Zone"
  type        = string
  default     = "false"
}
variable "tags" {
  description = "Default tags used by any resources"
  type        = map
  default = {}
}

/*variable "cloudtrail_name" {
  description = "Name of the CloudTrail"
  type        = string
  default     = "wiz-ctf-cloudtrail"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store the logs"
  type        = string
  default     = "wiz-ctf-cloudtrail-logs"
}

variable "s3_bucket_force_destroy" {
  description = "Force destroy the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable logging for the trail"
  type        = bool
  default     = true
}
 */

variable "multi_region" {
  description = "Enable multi-region trail"
  type        = bool
  default     = true
}

variable "global_service" {
  description = "Include global service events"
  type        = bool
  default     = true
}

variable "x_tags" {
  description = "Tags for the CloudTrail"
  type        = map
  default     = {}
}

variable "add_s3_bucket" {
  description = "Add an S3 bucket for the CloudTrail"
  type        = string
  default     = "true"
}

