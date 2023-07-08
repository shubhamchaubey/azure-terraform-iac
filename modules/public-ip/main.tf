resource "azurerm_public_ip" "example" {
  name                = var.pip-name
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = var.allocation_method #Static
  sku = var.sku #"Standard"
}