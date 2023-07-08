output "private_ip" {
  value = azurerm_container_group.private_aci.ip_address
}

output "aci_id" {
  value = azurerm_container_group.private_aci.id
}