variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "A map/dictionary of Tags to be assigned to created resources."
  default     = {}
}

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

variable "ragserver_role_arn" {
  type        = string
  description = "Sets the ragserver role that will access the bucket."
}