variable "proxmox_host" {
  type = string
}

variable "template_vm_id" {
  type = string
}

variable "name" {
  type = string
}

variable "cpu" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "vlan_id" {
  type = number
}

variable "ipv4_address" {
  type = string
}

variable "ipv4_gateway" {
  type = string
}
