output "admin_username" {
  value =  azurerm_container_registry.new-registry.admin_username
  sensitive = true
}

output "admin_password" {
  value = azurerm_container_registry.new-registry.admin_password
  sensitive = true
}

output "registry_url" {
  value = azurerm_container_registry.new-registry.login_server
  sensitive = true
}