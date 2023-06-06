locals {
  kubeconfig = yamldecode(data.tfe_outputs.cluster_infra.values.kube_config)
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
  url = "https://${data.tfe_outputs.cluster_infra.values.controlplane_gateway}"
  key = var.vyos_api_key
}
