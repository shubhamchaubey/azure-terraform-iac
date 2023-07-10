terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azuredevops" {
    org_service_url = var.org_url
    personal_access_token = var.pattf
}


resource "azuredevops_project" "example" {
  name               = "Terraform Project"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Basic"
}

resource "azuredevops_git_repository" "test_repo"{

project_id = azuredevops_project.example.id
name = "Terraform Project"
default_branch = "refs/heads/main"
initialization {
  init_type = "Clean"
}
}

resource "azuredevops_git_repository" "example-import" {
  project_id = azuredevops_project.example.id
  name       = "Example Import Repository"
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/creatorshubham/code-editor"
  }
}


locals{
   test_file_content = "# This is my test file"
   test_file_name = "test-file.txt"
}

resource "azuredevops_git_repository_file" "newfile" {
repository_id = azuredevops_project.example.id
file = local.test_file_name
content = base64encode(local.test_file_content)
branch              = "refs/heads/main"
 
}


# # vktheacyjwtvjxs6xzbqc2jdqx6q5w76fgrrptquppqbbcbyotzq