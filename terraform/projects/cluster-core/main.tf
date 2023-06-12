resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret_v1" "cloudflare_api_key" {
  metadata {
    name = "cloudflare-apikey-secret"
    namespace = "cert-manager"
  }
  data = {
    "apikey" = var.cloudflare_api_key
  }
}
