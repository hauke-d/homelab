resource "helm_release" "cilium" {
  name       = "cilium"
  chart = "${path.module}/charts/cilium"
  namespace  = "kube-system"
  dependency_update = true

  dynamic set {
    for_each = var.bgp_node_labels
    content {
      name = "bgpNodeLabels.${replace(set.key, ".", "\\.")}"
      value = "${set.value}"
    }
  }

  set {
    name = "bgpClusterAsn"
    value = var.bgp_cluster_asn
  }

  set {
    name = "bgpPeerAsn"
    value = var.bgp_vyos_asn
  }

  set {
    name = "bgpPeerAddress"
    value = var.bgp_gateway_address
  }

  set {
    name = "loadBalancerAddressPool"
    value = var.load_balancer_address_pool
  }

  set {
    name  = "cilium.k8sServiceHost"
    value = var.controlplane_address
  }

  set {
    name  = "cilium.k8sServicePort"
    value = "6443"
  }
}

resource "vyos_config" "bgp_system_asn" {
  key = "protocols bgp system-as"
  value = var.bgp_vyos_asn
}

resource "vyos_config" "bgp_address_family" {
  key = "protocols bgp address-family ipv4-unicast network 10.8.0.0/16"
  value = ""
  depends_on = [ vyos_config.bgp_system_asn ]
}


resource "vyos_config_block_tree" "bgp_neigbors" {
  for_each = toset(var.bgp_node_addresses)
  path     = "protocols bgp neighbor ${each.value}"
  configs = {
    "remote-as"                                      = var.bgp_cluster_asn
    "address-family ipv4-unicast nexthop-self force" = ""
    "description"                                    = "k8s ingress"
  }

  depends_on = [ 
    vyos_config.bgp_address_family, 
    vyos_config.bgp_system_asn
  ]
}
