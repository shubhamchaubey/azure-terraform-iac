terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "terraformstore2211"
    container_name       = "backend-container"
    key                  = "terraform.tfstate"
  }
}