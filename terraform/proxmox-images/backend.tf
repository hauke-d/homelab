terraform {
  cloud {
    organization = "hauke"

    workspaces {
      name = "proxmox-images"
    }
  }
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0"
    }
  }
}