
resource "azurerm_container_registry" "new-registry" {
  name                = "shubham22acr22"
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Premium"
  admin_enabled = true
  # georeplications {
  #   location                = "West US"
  #   zone_redundancy_enabled = true
  # }
}

resource "azurerm_container_registry_task" "build" {
  name                  = "build-task"
  container_registry_id = azurerm_container_registry.new-registry.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/creatorshubham/capstone"
    context_access_token = var.context_access_token
    image_names          = ["python-project:latest"]
  }
}

resource "azurerm_container_registry_task_schedule_run_now" "example" {
  container_registry_task_id = azurerm_container_registry_task.build.id
}