resource "kubernetes_namespace_v1" "cloudflare_api_key" {
  for_each = toset(var.cloudflare_api_key_namespaces)
  metadata {
    name = each.value
  }
}

resource "kubernetes_secret_v1" "cloudflare_api_key" {
  for_each = toset(var.cloudflare_api_key_namespaces)
  metadata {
    name = "cloudflare-apikey-secret"
    namespace = each.value
  }
  data = {
    "apikey" = var.cloudflare_api_key
  }
}
