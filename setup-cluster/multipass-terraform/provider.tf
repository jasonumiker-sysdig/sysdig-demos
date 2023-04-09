terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
  required_version = "1.4.3"
}

provider "helm" {
  kubernetes {
    config_path = "./kubeconfig"
  }
}