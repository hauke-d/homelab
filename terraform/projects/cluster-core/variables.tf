variable "cluster_endpoint" {
  default = "10.8.24.100"
}

variable "vyos_host" {
  default = "10.8.24.1"
}

variable "vyos_api_key" {}

variable "bgp_vyos_asn" {
  default = 64512
}

variable "bgp_cluster_asn" {
  default = 64512
}

variable "load_balancer_address_pool" {
  default = "10.8.25.0/24"
}
