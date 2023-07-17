  terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.0.2"
      }

       azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.0.0"
    }
    }
  }

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

data "azurerm_storage_account" "example" {
  name                = azurerm_storage_account.example.name
  resource_group_name = azurerm_resource_group.example.name

}

resource "azurerm_storage_container" "example" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = var.container_access_type
}

resource "azurerm_storage_blob" "example" {
  name                   = var.storage_name
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = var.storage_type
  # source                 = "./example.txt"
  source_uri = var.storage_source_uri
}

resource "azuread_user" "UserA" {
    user_principal_name = var.user_principal_name
    display_name = var.user_display_name
    password = var.user_pass
  
}

resource "azurerm_role_assignment" "Storage_role" {
  scope = azurerm_resource_group.example.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id = azuread_user.UserA.object_id

  depends_on = [ 
    azuread_user.UserA,
    azurerm_resource_group.example
   ]
}