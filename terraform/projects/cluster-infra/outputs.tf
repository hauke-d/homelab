output "talos_config" {
  value = module.talos_config.talos_config
  sensitive = true
}

output "kube_config" {
  value = module.talos_config.kube_config
  sensitive = true
}