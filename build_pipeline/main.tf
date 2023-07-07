terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azuredevops" {
    org_service_url = "https://dev.azure.com/shubham0045/"
    personal_access_token = var.pattf 
}

resource "azuredevops_project" "terraform_project" {
  name               = var.project_name
  visibility         = var.project_visibility
  version_control    = var.project_version_control
  work_item_template = "Basic"
}

resource "azuredevops_serviceendpoint_github" "github_conn" {
    project_id             = azuredevops_project.terraform_project.id
    service_endpoint_name  = var.github_service_endpoint_name

   auth_personal {
    personal_access_token = var.ghtoken
  }
  
}

resource "azuredevops_build_definition" "new_pipeline" {
  project_id = azuredevops_project.terraform_project.id
  name       = var.pipeline_name
  path       = var.pipeline_folder
  agent_pool_name = var.agent_pool_name
  depends_on = [ azuredevops_project.terraform_project ]
  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.repo_id
    branch_name           = "main"
    yml_path              = "azure-pipelines-1.yml"
    service_connection_id = azuredevops_serviceendpoint_github.github_conn.id
  }

#   schedules {
#     branch_filter {
#       include = ["main"]
#       exclude = ["test", "regression"]
#     }
#     days_to_build                = ["Sun", "Mon", "Tue", "Wed", "Sat"]
#     schedule_only_with_changes = true
#     start_hours                = 10
#     start_minutes              = 59
#     time_zone                  = "(UTC) Coordinated Universal Time"
#   }
}