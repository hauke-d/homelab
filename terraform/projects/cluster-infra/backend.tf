terraform {
  cloud {
    organization = "hauke"

    workspaces {
      name = "cluster-infra"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0"
    }
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
    github = {
      source = "integrations/github"
      version = "~> 5"
    }
  }
}
