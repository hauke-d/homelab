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

variable "kubernetes_master_hosts" {
  default = ["pm0", "pm1", "pm2"]
}

variable "kubernetes_worker_hosts" {
  default = ["pm0", "pm1", "pm2"]
}

variable "talos_version" {
  default = "v1.4.4"
}

variable "cluster_name" {
  default = "homelab"
}
