resource "random_password" "argocd_admin" {
  length = 16
}

resource "time_static" "password_timestamp" {
  triggers = {
    password = random_password.argocd_admin.bcrypt_hash
  }
}

resource "tls_private_key" "argocd_ssh_key" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "argocd" {
  title = "ArgoCD"
  repository = "homelab"
  key = tls_private_key.argocd_ssh_key.public_key_openssh
  read_only = true
}

resource "helm_release" "argocd" {
  name = "argo-cd"
  chart = "argo-cd"
  namespace = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  version = var.argocd_version
  create_namespace = true

  set {
    name = "configs.params.server\\.insecure"
    value = "true"
  }

  set {
    name = "configs.repositories.homelab.url"
    value = "git@github.com:hauke-d/homelab.git"
  }

  set {
    name = "configs.repositories.homelab.sshPrivateKey"
    value = tls_private_key.argocd_ssh_key.private_key_openssh
  }

  set {
    name = "configs.secret.argocdServerAdminPassword"
    value = random_password.argocd_admin.bcrypt_hash
  }

  set {
    name = "configs.secret.argocdServerAdminPasswordMtime"
    value = time_static.password_timestamp.id
  }
}

resource "kubectl_manifest" "default_app" {
  yaml_body = file("${path.module}/default-app.yaml")
  depends_on = [ helm_release.argocd ]
}
