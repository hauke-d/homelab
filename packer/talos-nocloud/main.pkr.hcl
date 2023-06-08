packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
    ssh_password = uuidv4()
}

source "proxmox-iso" "talos" {
  proxmox_url              = "${var.proxmox_endpoint}/api2/json"
  username                 = var.proxmox_user
  password                 = var.proxmox_password

  # provisioned through terraform/packer-base
  iso_file = "local:iso/archlinux-2023.05.03-amd64.iso"
  unmount_iso = true

  scsi_controller = "virtio-scsi-pci"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  disks {
    type              = "scsi"
    storage_pool      = "local"
    format            = "qcow2"
    disk_size         = "10G"
    cache_mode        = "writethrough"
  }

  memory       = 1024
  cores        = 2
  qemu_agent   = true

  ssh_username           = "root"
  ssh_password           = local.ssh_password
  ssh_timeout            = "5m"

  template_name        = "talos-${var.talos_version}"
  template_description = "Talos system disk"

  boot_wait = "10s"
  boot_command = [
    # Run live system, wait for boot
    "<enter><wait90s>",
    # set password for root ssh access
    "passwd<enter><wait>${local.ssh_password}<enter><wait>${local.ssh_password}<enter>",
  ]
}

build {
  name    = "release"

  dynamic "source" {
    for_each = var.proxmox_node_templates
    labels = ["proxmox-iso.talos"]
    content {
      node = source.key
      vm_id = source.value.vm_id
    }
  }

  provisioner "shell" {
    inline = [
      "curl -L https://github.com/siderolabs/talos/releases/download/${var.talos_version}/nocloud-amd64.raw.xz -o /tmp/talos.raw.xz",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
    ]
  }
}
