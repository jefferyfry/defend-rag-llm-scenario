terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }

    wiz = {
      version = " ~> 1.8"
      source  = "tf.app.wiz.io/wizsec/wiz"
    }
  }
}