locals {
  kubeconfig = yamldecode(data.tfe_outputs.cluster_core.values.kube_config)
  cluster    = local.kubeconfig.clusters[0].cluster
  user       = local.kubeconfig.users[0].user
}

provider "kubernetes" {
  host                   = local.cluster.server
  cluster_ca_certificate = base64decode(local.cluster.certificate-authority-data)
  client_certificate     = base64decode(local.user.client-certificate-data)
  client_key             = base64decode(local.user.client-key-data)
}
