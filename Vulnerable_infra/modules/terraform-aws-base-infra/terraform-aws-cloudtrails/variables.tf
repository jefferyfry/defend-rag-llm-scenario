variable "cloudtrail_name" {
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

variable "tags" {
  description = "Tags for the CloudTrail"
  type        = map
  default     = {}
}

variable "add_s3_bucket" {
  description = "Add an S3 bucket for the CloudTrail"
  type        = string
  default     = "true"
}
