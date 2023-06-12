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
      version = "~> 2"
    }
  }
}
