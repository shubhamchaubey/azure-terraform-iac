provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../modules/resource-group"

  rg_name = var.rg_name
  rg_location = var.rg_location
}

module "k8s-cluster" {
  source = "../modules/kube-cluster"

  cluster_name  = var.cluster_name
  location      = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  dns_prefix = var.dns_prefix
  system_node_count = var.system_node_count
  network_plugin = var.network_plugin
  load_balancer_sku = var.load_balancer_sku
  private_cluster_enabled = var.private_cluster_enabled
  azure_rbac_enabled = var.azure_rbac_enabled
}