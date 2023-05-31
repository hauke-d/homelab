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
