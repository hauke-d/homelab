variable "cluster_name" {
  default = "homelab"
}

variable "controlplane_ips" {
  type = list(string)
}

