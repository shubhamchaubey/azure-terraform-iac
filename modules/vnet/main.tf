resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.vnet_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "apg_subnet" {
  name                 = var.apg_subnet_name
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.apg_subnet_prefixes
}

resource "azurerm_subnet" "aci_subnet" {
  name                 = var.aci_subnet_name
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aci_subnet_prefixes
  delegation {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# # Create NSG for Subnet 
# resource "azurerm_network_security_group" "capstone_nsg" {
#   name                = "capstone_nsg"
#   location            = azurerm_resource_group.capstone_rg.location
#   resource_group_name = azurerm_resource_group.capstone_rg.name
#   security_rule {
#     # allow incoming port traffic from the internet
#     name                         = "AllowInternetInboundTrafficToSubnet"
#     priority                     = 100
#     direction                    = "Inbound"
#     access                       = "Allow"
#     protocol                     = "Tcp"
#     source_port_range            = "*"
#     destination_port_range       = "80, 443"
#     source_address_prefixes      = ["Internet"]
#     destination_address_prefixes = azurerm_virtual_network.capstone_vnet.address_space
#   }
# }
# # Associate NSG with the PUBLIC subnet   
# resource "azurerm_subnet_network_security_group_association" "snsga_public" {
#   network_security_group_id = azurerm_network_security_group.capstone_nsg.id
#   subnet_id                 = azurerm_subnet.public.id
# }

