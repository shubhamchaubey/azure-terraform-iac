variable "pattf" {
  type        = string
  sensitive   = true
}

variable "ghtoken" {
  type        = string
  sensitive   = true
}

variable "org_url" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_visibility" {
  type = string
}

variable "project_version_control" {
  type = string
}

variable "github_service_endpoint_name" {
  type = string
}

variable "pipeline_name" {
  type = string
}

variable "pipeline_folder" {
  type = string
}

variable "agent_pool_name" {
  type = string
}

variable "repo_id" {
  type = string
}