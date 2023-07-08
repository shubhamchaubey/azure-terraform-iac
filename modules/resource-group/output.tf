output "rg_name" {
  value = "${azurerm_resource_group.rg_group.name}"
}

output "rg_location" {
  value = "${azurerm_resource_group.rg_group.location}"
}
