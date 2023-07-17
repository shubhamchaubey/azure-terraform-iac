provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "new-account"
  location = "eastus"
}

resource "azurerm_storage_account" "test" {
  name                     = "newacctest22"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "test" {
  name                  = "new-container"
 
  storage_account_name  = azurerm_storage_account.test.name
  
}

resource "azurerm_storage_blob" "blob" {
  name                   = "first-blob"
  storage_account_name   = azurerm_storage_account.test.name
  storage_container_name = "new-container"
  type                   = "Block"
  source                 = "/home/knoldus/file.txt"
}

resource "azurerm_storage_management_policy" "example" {
 
  storage_account_id = azurerm_storage_account.test.id

 rule {
    name    = "rule1"
    enabled = true
    filters {
      prefix_match = ["new-container/first-blob"]
      blob_types   = ["blockBlob"]

    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 10
        tier_to_archive_after_days_since_modification_greater_than = 50
        delete_after_days_since_modification_greater_than          = 100
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }

  }