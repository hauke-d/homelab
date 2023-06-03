terraform {
  cloud {
    organization = "hauke"

    workspaces {
      name = "cluster-core"
    }
  }

  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~> 2"
    }
  }
}
