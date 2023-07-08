resource "azurerm_application_gateway" "example" {
  name                = var.gateway_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }
  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = var.pip-id
  }  
  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    capacity = 2
  }
  backend_address_pool {
    name         = "container_group_pool"
    ip_addresses = var.private_aci_ip_address
  }
  frontend_port {
    name = "http"
    port = 80
  }

  backend_http_settings {
    name                  = "http_path1"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  request_routing_rule {
    name                      = "rule1"
    rule_type                 = "Basic"
    http_listener_name        = "http-listener-1"
    backend_address_pool_name = "container_group_pool"
    backend_http_settings_name = "http_path1"
    priority = 2
  }

  http_listener {
    name                           = "http-listener-1"
    frontend_ip_configuration_name = "public-ip"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  frontend_port {
    name = "http2"
    port = 5000
  }

  backend_http_settings {
    name                  = "http_path2"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 5000
    protocol              = "Http"
    request_timeout       = 60
  }

  request_routing_rule {
    name                      = "rule2"
    rule_type                 = "Basic"
    http_listener_name        = "http-listener-2"
    backend_address_pool_name = "container_group_pool"
    backend_http_settings_name = "http_path2"
    priority = 1
  }

  http_listener {
    name                           = "http-listener-2"
    frontend_ip_configuration_name = "public-ip"
    frontend_port_name             = "http2"
    protocol                       = "Http"
  }
}