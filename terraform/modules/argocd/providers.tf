terraform {
  required_providers {
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
