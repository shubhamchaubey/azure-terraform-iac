provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cluster_rg" {
  name     = "cluster-rg"
  location = "Australia East"
}
resource "azurerm_resource_group" "resources-rg" {
  name     = "resources-rg"
  location = "East Us"
}

resource "azurerm_virtual_network" "cluster_vnet" {
  name                = "my-vnet01"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.cluster_rg.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
}

resource "azurerm_subnet" "cluster-subnet" {
  name                 = "my-subnet01"
  resource_group_name  = azurerm_resource_group.cluster_rg.name
  virtual_network_name = azurerm_virtual_network.cluster_vnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_virtual_network" "example-2" {
  name                = "my-vent02"
  resource_group_name = azurerm_resource_group.resources-rg.name
  address_space       = ["10.50.0.0/16"]
  location            = azurerm_resource_group.resources-rg.location
}
resource "azurerm_subnet" "example-2" {
  name = "my-subnet02"
  resource_group_name = azurerm_resource_group.resources-rg.name
  virtual_network_name = azurerm_virtual_network.example-2.name
  address_prefixes = ["10.50.0.0/24"]
}

resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.cluster_rg.name
  virtual_network_name      = azurerm_virtual_network.cluster_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.example-2.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.resources-rg.name
  virtual_network_name      = azurerm_virtual_network.example-2.name
  remote_virtual_network_id = azurerm_virtual_network.cluster_vnet.id
}

module "kube-cluster" {
  source = "../modules/kube-cluster"

  cluster_name = "new-cluster"
  location = azurerm_resource_group.cluster_rg.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  dns_prefix = "shubham22aks"
  system_node_count = 1
  admin_username = "shubham"
  network_plugin = "kubenet"
  load_balancer_sku = "standard"
  private_cluster_enabled = true
  azure_rbac_enabled = true
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.resources-rg.location
  resource_group_name = azurerm_resource_group.resources-rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.resources-rg.location
  resource_group_name = azurerm_resource_group.resources-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.resources-rg.location
  resource_group_name = azurerm_resource_group.resources-rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.example-2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_vnet" {
  name = "dnslink-vnet02"
  private_dns_zone_name = join(".", slice(split(".", module.kube-cluster.private_fqdn), 1, length(split(".", module.kube-cluster.private_fqdn))))
  resource_group_name   = "MC_${azurerm_resource_group.cluster_rg.name}_${module.kube-cluster.cluster_name}_${azurerm_resource_group.cluster_rg.location}"
  virtual_network_id    = azurerm_virtual_network.example-2.id
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM1"
  location              = azurerm_resource_group.resources-rg.location
  resource_group_name   = azurerm_resource_group.resources-rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password = "Admin_152012345"
  disable_password_authentication = false

  user_data = base64encode(file("./script.sh"))

}