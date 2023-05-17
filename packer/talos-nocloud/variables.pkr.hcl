variable "proxmox_endpoint" {
  default = "https://localhost:8006"
}

variable "proxmox_user" {
  default = "root@pam"
}

variable "proxmox_password" {
  sensitive = true
  type = string
}