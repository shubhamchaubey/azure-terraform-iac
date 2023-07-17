# Provider Configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "shubham-rg"
  location = "West US"
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "my-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "ex_subnet" {
  name                 = "new-subnet"
  resource_group_name  = azurerm_virtual_network.example.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/18"]
}

# Storage Account
resource "azurerm_storage_account" "example" {
  name                     = "sgacshubham2211"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface" "nic" {
    name                = "nic-01"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    ip_configuration {
        name                          = "ipconfiguration1"
        subnet_id                     = azurerm_subnet.ex_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}
# Virtual Machine
resource "azurerm_virtual_machine" "example" {
  name                  = "my-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.nic.id]

  vm_size              = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "my-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_recovery_services_vault" "example" {
  name                = "tfex-recovery-vault"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  soft_delete_enabled = false
}

resource "azurerm_backup_policy_vm" "example" {
  name                = "tfex-recovery-vault-policy"
  resource_group_name = azurerm_resource_group.example.name
  recovery_vault_name = azurerm_recovery_services_vault.example.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

resource "azurerm_backup_protected_vm" "vm1" {
  resource_group_name = azurerm_resource_group.example.name
  recovery_vault_name = azurerm_recovery_services_vault.example.name
  source_vm_id        = azurerm_virtual_machine.example.id
  backup_policy_id    = azurerm_backup_policy_vm.example.id
}
# # Azure Site Recovery Configuration
# resource "azurerm_site_recovery_replication_protected_vm" "example" {
#   name                 = "my-protected-vm"
#   resource_group_name  = azurerm_resource_group.example.name
#   recovery_resource_id = azurerm_virtual_machine.example.id
#   recovery_os_type     = "Linux"
#   target_location      = "West US"

#   enable_auto_shutdown   = true
#   auto_shutdown_schedule = "Sun.23:00-Sun.23:59"
# }

# # Disaster Recovery Plan
# resource "azurerm_site_recovery_recovery_plan" "example" {
#   name                 = "my-recovery-plan"
#   resource_group_name  = azurerm_resource_group.example.name
#   failover_direction   = "PrimaryToSecondary"
#   primary_site_location= "West US"
#   recovery_site_location = "East US"

#   replication_vm_groups {
#     name               = "my-replication-vm-group"
#     replication_protected_vm_id = azurerm_site_recovery_replication_protected_vm.example.id
#   }
# }
