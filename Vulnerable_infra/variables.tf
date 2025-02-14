variable "region" {
  description = "Default region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Default environment"
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Default prefix"
  type        = string
  default     = ""
}

variable "suffix" {
  description = "Default suffix"
  type        = string
  default     = ""
}

variable "use_wiz_sensor" {
  type    = bool
  default = false
}

variable "client_id" {
  type    = string
}

variable "client_secret" {
  type    = string
}

variable vpc_azs {
  type    = list(string)
}
