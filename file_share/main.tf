# resource "azurerm_resource_group" "new" {
#   name     = var.resource_group_name
#   location = var.location
# }

provider "azurerm" {
  features {}
}

module "resource-group" {
  source = "../modules/resource-group"

  rg_name = var.resource_group_name
  rg_location = var.location
}

resource "azurerm_storage_account" "new" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.storage_account_kind
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  access_tier              = "Hot"

  # static_website {
  #   index_document     = var.static_website_index_document
  #   error_404_document = var.static_website_error_404_document
  # }
}

resource "azurerm_storage_share" "fs" {
  name                 = "first-share"
  storage_account_name = azurerm_storage_account.new.name
  quota                = 1
}

resource "azurerm_storage_share_file" "example" {
  name             = "script.sh"
  storage_share_id = azurerm_storage_share.fs.id
  source           = "./script.sh"
}

