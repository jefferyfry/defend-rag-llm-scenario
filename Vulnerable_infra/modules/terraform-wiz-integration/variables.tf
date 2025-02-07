variable "environment" {
  type        = string
  description = "A string representing the environment for all created resources."
}

variable "prefix" {
  type        = string
  description = "A string representing the prefix for all created resources."
}

variable "suffix" {
  type        = string
  description = "A string representing the suffix for all created resources."
}

variable "tags" {
  type        = map(string)
  description = "A map/dictionary of Tags to be assigned to created resources."
  default     = {}
}

variable "cloudtrail_bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket to store the CloudTrail logs."
}

variable "cloudtrail_bucket_name" {
  type        = string
  description = "The name of the bucket used for CloudTrail."
}