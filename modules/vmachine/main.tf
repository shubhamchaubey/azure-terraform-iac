resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vmname
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = var.network_interface_ids
  admin_ssh_key {
    username   = var.admin_username
    public_key = file("/home/knoldus/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.vmname}-os-disk-01"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }
}
