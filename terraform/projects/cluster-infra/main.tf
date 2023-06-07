locals {
  controlplane_ips = keys(var.controlplane_nodes)
}

module "controlplane" {
  for_each = var.controlplane_nodes
  source   = "../../modules/talos-vm"

  name           = "${var.cluster_name}-controlplane"
  proxmox_host   = each.value.host
  template_vm_id = each.value.template_id
  vlan_id        = var.vlan_id
  ipv4_address   = "${each.key}${var.vlan_cidr}"
  ipv4_gateway   = var.vyos_gateway
}

module "talos_config" {
  source                  = "../../modules/talos-config"
  cluster_name            = var.cluster_name
  controlplane_ips        = local.controlplane_ips
  controlplane_virtual_ip = var.controlplane_virtual_ip
  depends_on              = [module.controlplane]
}

module "cilium" {
  source                     = "../../modules/cilium"
  controlplane_address       = var.controlplane_virtual_ip
  bgp_node_addresses         = keys(var.controlplane_nodes)
  bgp_gateway_address        = var.vyos_gateway
  load_balancer_address_pool = var.load_balancer_address_pool
}
