variable "cluster_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "system_node_count" {
  type = number
}

variable "network_plugin" {
  type = string
}

variable "load_balancer_sku" {
  type = string
}

variable "private_cluster_enabled" {
  type = bool
}

variable "azure_rbac_enabled" {
  type = bool
}

variable "admin_username" {
  type = string
}