terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "~> 1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2"
    }
    vyos = {
      source  = "foltik/vyos"
      version = "~> 0"
    }
  }
}
