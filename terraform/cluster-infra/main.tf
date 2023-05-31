module "controlplane-0" {
    source = "./modules/controlplane-vm"

    name = "controlplane-0"
    proxmox_host = "pm0"
    template_vm_id = 103
    vlan_id = 24
    ipv4_address = "10.8.24.100/21"
    ipv4_gateway = "10.8.24.1"
}

module "controlplane-1" {
    source = "./modules/controlplane-vm"

    name = "controlplane-1"
    proxmox_host = "pm1"
    template_vm_id = 101
    vlan_id = 24
    ipv4_address = "10.8.24.101/21"
    ipv4_gateway = "10.8.24.1"
}

module "controlplane-2" {
    source = "./modules/controlplane-vm"

    name = "controlplane-2"
    proxmox_host = "pm2"
    template_vm_id = 102
    vlan_id = 24
    ipv4_address = "10.8.24.102/21"
    ipv4_gateway = "10.8.24.1"
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://10.8.24.100:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [
    "10.8.24.100",
    "10.8.24.101",
    "10.8.24.102"
  ]
}

data "helm_template" "cilium" {
  name = "cilium"
  namespace = "kube-system"
  repository = "https://helm.cilium.io/"
  chart = "cilium"
  version = "1.13.2"

  set {
    name = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name = "kubeProxyReplacement"
    value = "strict"
  }

  set {
    name = "securityContext.capabilities.ciliumAgent"
    value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
  }

  set {
    name = "securityContext.capabilities.cleanCiliumState"
    value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
  }

  set {
    name = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  set {
    name = "bgp.enabled"
    value = "true"
  }

  set {
    name = "bgp.announce.loadbalancerIP"
    value = "true"
  }

  set {
    name = "ingressController.enabled"
    value = "true"
  }

  set {
    name = "ingressController.loadbalancerMode"
    value = "dedicated"
  }

  set {
    name = "k8sServiceHost"
    value = "10.8.24.100"
  }

  set {
    name = "k8sServicePort"
    value = "6443"
  }
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = toset([
    "10.8.24.100",
    "10.8.24.101",
    "10.8.24.102"
  ])
  node                        = each.value
  config_patches = [
    templatefile("${path.module}/config.yaml", {
      hostname     = replace(each.value, ".", "-")
      cilium_yaml  = data.helm_template.cilium.manifest
    }),

  ]

  depends_on = [ module.controlplane-0, module.controlplane-1, module.controlplane-2 ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 =  "10.8.24.100"
}

data "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = "10.8.24.100"
  wait                 = true
}
