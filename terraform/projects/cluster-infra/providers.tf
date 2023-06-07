provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_user
  password = var.proxmox_password
}

locals {
  kubeconfig = yamldecode(module.talos_config.kube_config)
  cluster    = local.kubeconfig.clusters[0].cluster
  user       = local.kubeconfig.users[0].user
}

provider "kubectl" {
  host                   = local.cluster.server
  cluster_ca_certificate = base64decode(local.cluster.certificate-authority-data)
  client_certificate     = base64decode(local.user.client-certificate-data)
  client_key             = base64decode(local.user.client-key-data)
}

provider "helm" {
  kubernetes {
    host                   = local.cluster.server
    cluster_ca_certificate = base64decode(local.cluster.certificate-authority-data)
    client_certificate     = base64decode(local.user.client-certificate-data)
    client_key             = base64decode(local.user.client-key-data)
  }
}

provider "vyos" {
  url = "https://${var.vyos_gateway}"
  key = var.vyos_api_key
}
