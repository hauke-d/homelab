variable "cloudflare_api_key" {
  type = string
  sensitive = true
}

variable "cloudflare_api_key_namespaces" {
  default = [
    "cert-manager",
    "external-dns"
  ]
}
