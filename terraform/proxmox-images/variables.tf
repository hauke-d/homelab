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

variable "ssh_bastion_host" {
  default = "192.168.0.254"
}

variable "ssh_bastion_user" {
  default = "ansible"
}