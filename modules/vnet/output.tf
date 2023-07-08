output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "apg_subnet_id" {
    description = "id of the subnet"
    value = azurerm_subnet.apg_subnet.id
}

output "aci_subnet_id" {
    description = "id of the subnet"
    value = azurerm_subnet.aci_subnet.id
}