variable "proxmox_endpoint" {
  default = "https://10.8.0.10:8006"
}

variable "proxmox_user" {
  default = "root@pam"
}

variable "proxmox_password" {
  sensitive = true
  type      = string
}

variable "cluster_name" {
  default = "homelab"
}

variable "vlan_id" {
  default = 24
}

variable "vlan_cidr" {
  default = "/21"
}

variable "vyos_gateway" {
  default = "10.8.24.1"
}

variable "vyos_api_key" {
  sensitive = true
  type      = string
}

variable "controlplane_virtual_ip" {
  default = "10.8.24.100"
}

variable "load_balancer_address_pool" {
  default = "10.8.25.0/24"
}

variable "controlplane_nodes" {
  default = {
    "10.8.24.101" = {
      host        = "pm0"
      template_id = 103
    },
    "10.8.24.102" = {
      host        = "pm1"
      template_id = 101
    },
    "10.8.24.103" = {
      host        = "pm2"
      template_id = 102
    },
  }
}
