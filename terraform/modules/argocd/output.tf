output "argocd_admin_password" {
  value = random_password.argocd_admin.result
  sensitive = true
}
