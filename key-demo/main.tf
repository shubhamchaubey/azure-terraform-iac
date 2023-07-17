provider "azurerm" {
  features { }
}
module "resource_group" {
  source = "../modules/resource-group"
  rg_name = "cluster-rg"
  rg_location = "eastus"
}

module "kube-cluster" {
  source = "../modules/kube-cluster"

  cluster_name = var.cluster_name
  location = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  dns_prefix = var.dns_prefix
  system_node_count = 1
  admin_username = var.admin_username
  network_plugin = var.network_plugin
  load_balancer_sku = var.load_balancer_sku
  private_cluster_enabled = false
  azure_rbac_enabled = true
}
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "cluster_info" {
  name                        = "shubhamdemo2211"
  location                    = module.resource_group.rg_location
  resource_group_name         = module.resource_group.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "Create",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]

  }
}  

resource "azurerm_key_vault_secret" "kube_config" {
  name         = "kube-config"
  value        = module.kube-cluster.kube_config
  key_vault_id = azurerm_key_vault.cluster_info.id
}

resource "azurerm_key_vault_secret" "cluster_name" {
  name         = "cluster-name"
  value        = module.kube-cluster.cluster_name
  key_vault_id = azurerm_key_vault.cluster_info.id
}