variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "ip_address_type" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "registry_url" {
  type = string
  sensitive = true
}

variable "registry_username" {
  type = string
  sensitive = true
}

variable "registry_password" {
  type = string
  sensitive = true
}