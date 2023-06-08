variable "proxmox_endpoint" {
  default = "https://10.8.0.10:8006"
}

variable "proxmox_user" {
  default = "root@pam"
}

variable "proxmox_password" {
  sensitive = true
  type = string
}

variable "proxmox_node_templates" {
  default = {
    "pm0" = { 
      vm_id = 1450
    }
    "pm1" = { 
      vm_id = 1451
    }
    "pm2" = {
      vm_id = 1452
    }
  }
}

variable "talos_version" {
  default = "v1.4.5"
}
