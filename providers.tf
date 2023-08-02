terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path    = "C:/Users/bb/.kube/config"
  config_context = "microk8s"
}