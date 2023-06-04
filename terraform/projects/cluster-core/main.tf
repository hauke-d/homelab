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
    value = var.cluster_endpoint
  }

  set {
    name  = "k8sServicePort"
    value = "6443"
  }
}

# TODO: Adding this without cilium running will fail (needs CRDs applied by cilium-operator)
resource "kubernetes_manifest" "bgp_policy" {
  manifest = {
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
          localASN = 64512
          neighbors = [
            {
              peerASN     = 64512
              peerAddress = "10.8.24.1/32"
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
  }
  field_manager {
    force_conflicts = true
  }
}

# TODO: Adding this without cilium running will fail (needs CRDs applied by cilium-operator)
resource "kubernetes_manifest" "loadbalancer_ip_pool" {
  manifest = {
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumLoadBalancerIPPool"
    metadata = {
      name = "ingress"
    }
    spec = {
      cidrs    = [{ cidr = "10.8.25.0/24" }]
      disabled = "false"
      serviceSelector = {
        matchLabels = {
          "cilium.io/ingress" = "true"
        }
      }
    }
  }
  field_manager {
    force_conflicts = true
  }
}

