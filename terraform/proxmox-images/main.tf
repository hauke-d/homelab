data "proxmox_virtual_environment_nodes" "cluster" {}

resource "proxmox_virtual_environment_file" "debian_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pm0"
  
  source_file {
    path = "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.7.0-amd64-standard.iso"
    file_name = "debian-11.7.0-amd64.iso"
  }
}
 
resource "proxmox_virtual_environment_file" "archlinux_image" {
  for_each = toset(data.proxmox_virtual_environment_nodes.current.names)
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value
  
  source_file {
    path = "https://mirrors.dotsrc.org/archlinux/iso/2023.05.03/archlinux-x86_64.iso"
    file_name = "archlinux-2023.05.03-amd64.iso"
  }
}

resource "proxmox_virtual_environment_file" "talos_image" {
  for_each = toset(data.proxmox_virtual_environment_nodes.current.names)
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value
  
  source_file {
    path = "https://github.com/siderolabs/talos/releases/download/v1.4.4/talos-amd64.iso"
    file_name = "talos-v1.4.4-amd64.iso"
  }
}
