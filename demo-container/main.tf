provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../modules/resource-group"

  rg_name = var.rg_name
  rg_location = var.rg_location
}
module "vnet_and_subnet" {
  source = "../modules/vnet"

  vnet_name = var.vnet_name
  vnet_address_space = var.vnet_address_space
  vnet_location = module.resource_group.rg_location
  rg_name = module.resource_group.rg_name
  apg_subnet_name = var.apg_subnet_name
  apg_subnet_prefixes = var.apg_subnet_prefixes

  aci_subnet_name = var.aci_subnet_name
  aci_subnet_prefixes = var.aci_subnet_prefixes
}

module "pip-creation" {
  source = "../modules/public-ip"

  pip-name = var.pip-name
  allocation_method = var.allocation_method
  rg_name = module.resource_group.rg_name
  rg_location = module.resource_group.rg_location
  sku = var.sku
}

module "app-gateway" {
  source = "../modules/app-gateway"

  gateway_name = "shubham-apg"
  rg_name = module.resource_group.rg_name
  rg_location = module.resource_group.rg_location
  subnet_id = module.vnet_and_subnet.apg_subnet_id
  pip-id = module.pip-creation.pip_id
  private_aci_ip_address = [module.private-aci.private_ip]
}

module "private-aci" {
    source = "../modules/private-container-group"

    rg_name = module.resource_group.rg_name
    rg_location = module.resource_group.rg_location
    ip_address_type = var.ip_address_type
    subnet_ids = [module.vnet_and_subnet.aci_subnet_id] 

    registry_url = module.acr.registry_url
    registry_username = module.acr.admin_username
    registry_password = module.acr.admin_password
    depends_on = [ module.acr ]
}

module "acr" {
  source = "../modules/private-registry"

  rg_name = module.resource_group.rg_name
  rg_location = module.resource_group.rg_location
  context_access_token = var.ghtoken
}