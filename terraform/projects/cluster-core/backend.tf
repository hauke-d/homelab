terraform {
  cloud {
    organization = "hauke"

    workspaces {
      name = "cluster-core"
    }
  }

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
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
