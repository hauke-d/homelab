variable "cluster_name" {
  default = "homelab"
}

variable "controlplane_ips" {
  type = list(string)
}

variable "controlplane_virtual_ip" {
  type = string
}

variable "cilium_version" {
  type = string
}
