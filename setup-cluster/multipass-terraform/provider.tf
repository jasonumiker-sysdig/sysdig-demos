terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "./kubeconfig"
  }
}