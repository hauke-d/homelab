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
      source = "hashicorp/helm"
      version = "~> 2"
    }
  }
}
