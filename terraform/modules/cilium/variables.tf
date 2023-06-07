variable "controlplane_address" {
  description = "The (virtual) IP of the Kuberentes API server"
  type = string
}

variable "load_balancer_address_pool" {
  description = "CIDR range for load balancer IP addresses"
  type = string
}

variable "bgp_gateway_address" {
  description = "The IP address of the gateway to advertise load balancer IPs to"
  type = string
}

variable "bgp_node_addresses" {
  description = "IPs of the nodes acting virtual routers for load balancer services"
  type = list(string)
}

variable "bgp_node_labels" {
  description = "A label selector to select all the nodes acting as virtual routers"
  type = map(string)
  default = {
    "node-role.kubernetes.io/control-plane" = ""
  }
}

variable "bgp_vyos_asn" {
  default = 64512
}

variable "bgp_cluster_asn" {
  default = 64512
}
