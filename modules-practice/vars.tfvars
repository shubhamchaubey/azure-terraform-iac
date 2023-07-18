rg-name = "shubham-terraform"
rg_location = "eastus"

vnet_name = "shubham-terraform-vnet"
vnet-address_space = ["10.20.0.0/16"]
vnet_location = "eastus"
pub_subnet_name = "public"
pub_subnet_prefix = ["10.20.0.0/18"]
private_subnet_name = "private"
private_subnet_prefix = ["10.20.64.0/18"]
vmname = "shubham-vm"
vm_size = "Standard_DS1_v2"
admin_username = "azureuser"
admin_password = "shubham@22"
os_disk_type = "Standard_LRS"
image_publisher = "Canonical"
image_offer = "UbuntuServer"
image_sku = "16.04-LTS"