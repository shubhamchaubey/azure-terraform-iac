output "id" {
  value = azurerm_kubernetes_cluster.example.id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}

output "private_fqdn" {
  value = azurerm_kubernetes_cluster.example.private_fqdn
}