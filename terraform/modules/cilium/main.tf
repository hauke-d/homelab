resource "helm_release" "cilium" {
  name = "cilium"
  chart = "cilium"
  namespace = "kube-system"
  repository = "https://helm.cilium.io/"
  version = var.cilium_version

  values = [ file("${path.module}/cilium-values.yaml") ]

  set {
    name = "k8sServiceHost"
    value = var.controlplane_address
  }

  set {
    name = "k8sServicePort"
    value = "6443"
  }
}

data "http" "cilium_crds" {
  for_each = toset(var.pre_install_crds)
  url = "https://raw.githubusercontent.com/cilium/cilium/${var.cilium_version}/pkg/k8s/apis/cilium.io/client/crds/${each.value}.yaml"
}
# Need to pre-install some CRDs, the operator takes over the rest. 
resource "kubectl_manifest" "cilium_crds" {
  for_each = toset(var.pre_install_crds)
  yaml_body = data.http.cilium_crds[each.value].response_body
}

resource "helm_release" "cilium_bgp" {
  name       = "cilium-bgp"
  chart = "${path.module}/charts/cilium-bgp"
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

  depends_on = [ kubectl_manifest.cilium_crds ]
}

locals {
  vyos_bgp_base = {
    "address-family ipv4-unicast network 10.8.0.0/16" = ""
    "system-as" = var.bgp_vyos_asn
  }
  vyos_bgp_neighbors = [
    for val in var.bgp_node_addresses : {
      "neighbor ${val} remote-as" = var.bgp_cluster_asn
      "neighbor ${val} address-family ipv4-unicast nexthop-self force" = ""
      "neighbor ${val} description" = "k8s ingress" 
    }
  ]
}

resource "vyos_config_block_tree" "router_config" {
  path = "protocols bgp"
  configs = merge(local.vyos_bgp_base, local.vyos_bgp_neighbors...)
}
