output "talos_config" {
  value     = module.talos_config.talos_config
  sensitive = true
}

output "kube_config" {
  value     = module.talos_config.kube_config
  sensitive = true
}

output "controlplane_address" {
  value = var.controlplane_virtual_ip
}

output "argocd_admin_password" {
  value = module.argocd.argocd_admin_password
  sensitive = true
}
