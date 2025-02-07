terraform {
  required_version = "~> 1.6"

  required_providers {
    azurerm = {
      version = " ~> 3.108"
      source  = "hashicorp/azurerm"
    }
  }
}