terraform {
  backend "azurerm" {
    resource_group_name  = "cluster"
    storage_account_name = "shubham2211rg"
    container_name       = "backend-container"
    key                  = "terraform.tfstate"
  }
}