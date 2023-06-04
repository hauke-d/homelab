data "proxmox_virtual_environment_nodes" "cluster" {}

resource "proxmox_virtual_environment_file" "archlinux_image" {
  for_each     = toset(data.proxmox_virtual_environment_nodes.current.names)
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value

  source_file {
    path      = "https://mirrors.dotsrc.org/archlinux/iso/2023.05.03/archlinux-x86_64.iso"
    file_name = "archlinux-2023.05.03-amd64.iso"
  }
}
