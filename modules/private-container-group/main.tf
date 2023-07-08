resource "azurerm_container_group" "private_aci" {
  name                = "my-private-aci"
  resource_group_name = var.rg_name
  location            = var.rg_location
  ip_address_type     = var.ip_address_type
  os_type             = "Linux"
  subnet_ids          = var.subnet_ids
  image_registry_credential{
    server                        	= var.registry_url
    username                        = var.registry_username
    password                        = var.registry_password
  }
  container {
    name   = "my-app"
    image  = "${var.registry_url}/python-project:latest"
    cpu    = "0.5"
    memory = "0.2"
    ports {
      port     = 5000
      protocol = "TCP"
    }
  }

  container {
    name   = "my-app-2cont"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "0.2"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}


