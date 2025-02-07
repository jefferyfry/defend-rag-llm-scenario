variable "zone" {
  description = "The zone in which the resources will be created."
  type        = string
}

variable "location" {
  description = "The location in which the resources will be created."
  type        = string
}

variable "name" {
  description = "The name of the resources to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}


variable "admin_username" {
  description = "The username of the admin."
  type        = string
}

variable "custom_data" {
  description = "The custom data to be used for the VM."
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet."
  type        = string
}