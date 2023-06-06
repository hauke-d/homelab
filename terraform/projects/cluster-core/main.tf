resource "helm_release" "cilium" {
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.14.0-snapshot.3"

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "strict"
  }

  set {
    name  = "securityContext.capabilities.ciliumAgent"
    value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
  }

  set {
    name  = "securityContext.capabilities.cleanCiliumState"
    value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
  }

  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  set {
    name  = "bgpControlPlane.enabled"
    value = "true"
  }

  set {
    name  = "ingressController.enabled"
    value = "true"
  }

  set {
    name  = "ingressController.loadbalancerMode"
    value = "shared"
  }

  set {
    name  = "loadBalancer.l7.backend"
    value = "envoy"
  }

  set {
    name  = "dnsPolicy"
    value = "ClusterFirstWithHostNet"
  }

  set {
    name  = "k8sServiceHost"
    value = data.tfe_outputs.cluster_infra.values.controlplane_address
  }

  set {
    name  = "k8sServicePort"
    value = "6443"
  }
}

resource "kubectl_manifest" "bgp_policy" {
  server_side_apply = true
  yaml_body = yamlencode({
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumBGPPeeringPolicy"
    metadata = {
      name = "vyos"
    }
    spec = {
      nodeSelector = {
        matchLabels = {
          "node-role.kubernetes.io/control-plane" = ""
        }
      }
      virtualRouters = [
        {
          localASN = var.bgp_cluster_asn
          neighbors = [
            {
              peerASN     = var.bgp_vyos_asn
              peerAddress = "${data.tfe_outputs.cluster_infra.values.controlplane_gateway}/32"
            }
          ]
          serviceSelector = {
            matchLabels = {
              "cilium.io/ingress" = "true"
            }
          }
        }
      ]
    }
  })
  depends_on = [ helm_release.cilium ]
}

resource "kubectl_manifest" "loadbalancer_ip_pool" {
  server_side_apply = true
  yaml_body = yamlencode({
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumLoadBalancerIPPool"
    metadata = {
      name = "ingress"
    }
    spec = {
      cidrs    = [{ cidr = var.load_balancer_address_pool }]
      disabled = false
      serviceSelector = {
        matchLabels = {
          "cilium.io/ingress" = "true"
        }
      }
    }
  })
  depends_on = [ helm_release.cilium ]
}

resource "vyos_config" "bgp_network" {
  key   = "protocols bgp address-family ipv4-unicast network 10.8.0.0/16"
  value = ""
}

resource "vyos_config" "bgp_system_asn" {
  key   = "protocols bgp system-as"
  value = var.bgp_vyos_asn
}

resource "vyos_config_block_tree" "bgp_neigbors" {
  for_each = toset(nonsensitive(data.tfe_outputs.cluster_infra.values.controlplane_nodes))
  path     = "protocols bgp neighbor ${each.value}"
  configs = {
    "remote-as"                                      = var.bgp_cluster_asn
    "address-family ipv4-unicast nexthop-self force" = ""
    "description"                                    = "k8s ingress"
  }
}
