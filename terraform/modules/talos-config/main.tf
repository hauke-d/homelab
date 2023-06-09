resource "talos_machine_secrets" "this" {}

locals {
  cluster_endpoint_ip = var.controlplane_ips[0]
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.controlplane_virtual_ip}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = var.controlplane_ips
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each                    = toset(var.controlplane_ips)
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = each.value
  config_patches = [
    templatefile("${path.module}/config.yaml", {
      hostname = replace(each.value, ".", "-")
      node_ip = each.value
      controlplane_virtual_ip = var.controlplane_virtual_ip
    }),
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.cluster_endpoint_ip
}

resource "time_sleep" "wait_after_bootstrap" {
  create_duration = "30s"

  depends_on = [ talos_machine_bootstrap.this ]
}

data "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.controlplane_virtual_ip
  wait                 = true

  depends_on = [
    talos_machine_bootstrap.this,
    time_sleep.wait_after_bootstrap
  ]
}
