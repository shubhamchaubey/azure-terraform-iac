resource "azurerm_kubernetes_cluster" "example" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "default"
    node_count          = var.system_node_count
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    max_count           = 2
    min_count           = 1
    vm_size             = "Standard_DS2_v2"
  }
 
  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJpVO+v2tCTRFuySTleGM3asnzE0kC2lWPnjCHESJRYXvWT+bmpOPgd/8nB9Zq9CfV8w2gq4VgwK5PcmvPYN7h/bz/ayixksS7tREbpIygCSOmd7NQAUueXFFtvgjb7mMCLWNgXbc4mSK+8eb2SiIyJO7aDrYt3fmr+UkTC690PfZTFYspivG3IcHmF8vLBMyCh10db5xFUZYIX8b6bjZeJIY/eIZFZyDqGJPut62Z9rbFjy8xTVFiAjO6zgduH4zZWGEM0P75Ay+kNaL/0cU242DwInE39qlq7qtiRBC+8HYl+P3iloLfY347o20+tiKhELIV6+WOBG6USunSJvngfAIdS8Rk6sk9pJUZGbuMwTlGhNlVbI4UEeMp2hPZPhTG6FHNyIhaqEH6fyvDwtDb69s/w0Sm5DBavgvvLDXUpRGFhAp5/22vYEekgkljBeHVwuD0yS3OnonSI77q6XSDzYI4K/jO5ypsY7bQFoiJxkSCstXJm40ShXb4ajtvhW0= shubham.chaubey@knoldus.com"
    }
  }
  network_profile {
    network_plugin    = var.network_plugin 
    dns_service_ip     = "192.168.1.1"
    service_cidr       = "192.168.0.0/16"
    pod_cidr           = "172.16.0.0/22"
    load_balancer_sku = var.load_balancer_sku 
  }

  identity {
    type = "SystemAssigned"
  }

  private_cluster_enabled = var.private_cluster_enabled 

  azure_active_directory_role_based_access_control{
    managed = true
    azure_rbac_enabled = var.azure_rbac_enabled
    admin_group_object_ids = [ "56a0be8e-1292-4748-8304-a86431bff002" ]
  }

  lifecycle {
    ignore_changes = [ default_node_pool ]
  }
}