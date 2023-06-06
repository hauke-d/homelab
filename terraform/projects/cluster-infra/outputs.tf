output "talos_config" {
  value     = module.talos_config.talos_config
  sensitive = true
}

output "kube_config" {
  value     = module.talos_config.kube_config
  sensitive = true
}

output "controlplane_nodes" {
  value = keys(var.controlplane_nodes)
}

output "controlplane_address" {
  value = var.controlplane_virtual_ip
}

output "controlplane_gateway" {
  value = var.vlan_gateway
}
