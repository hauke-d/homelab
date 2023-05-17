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
  }
}