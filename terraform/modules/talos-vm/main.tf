resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name
  node_name   = var.proxmox_host

  clone {
    vm_id = var.template_vm_id
  }

  agent {
    enabled = false
  }

  initialization {
    datastore_id = "local"
    dns {
        server = var.ipv4_gateway
    }
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = var.vlan_id
  }

  operating_system {
    type = "l26"
  }

  cpu {
    cores = var.cpu
    type = "host"
  }

  memory {
    dedicated = var.memory
  }
}
