provider "azurerm" {
  features {}
}

module "rg_group" {
  source = "../modules/resource-group"

  rg_name     = var.rg-name
  rg_location = var.rg_location
}

module "vnet" {
  source = "../modules/vnet"

  vnet_name             = var.vnet_name
  vnet_address_space    = var.vnet-address_space
  vnet_location         = var.vnet_location
  rg_name               = module.rg_group.rg_name
  pub_subnet_name       = var.pub_subnet_name
  pub_subnet_prefix     = var.pub_subnet_prefix
  private_subnet_name   = var.private_subnet_name
  private_subnet_prefix = var.private_subnet_prefix
}

module "nic" {
  source                = "../modules/nic"

  vmname                = var.vmname
  location              = module.rg_group.rg_location
  resource_group_name   = module.rg_group.rg_name
  subnet_id             = module.vnet.public_subnet_id
}

module "vmachine" {
  source                = "../modules/vmachine"

  vmname                = var.vmname
  resource_group_name   = module.rg_group.rg_name
  location              = module.rg_group.rg_location
  vm_size               = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [module.nic.nic_id]
  os_disk_type          = var.os_disk_type
  image_publisher       = var.image_publisher
  image_offer           = var.image_offer
  image_sku             = var.image_sku
}