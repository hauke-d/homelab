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
    github = {
      source = "integrations/github"
      version = "~> 5"
    }
  }
}
