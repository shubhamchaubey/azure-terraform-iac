# Create a Resource Group
resource "azurerm_resource_group" "rg_group" {
  name     = var.rg_name
  location = var.rg_location
}