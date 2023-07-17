variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "pip-name" {
  type = string
}

variable "allocation_method" {
  type = string
}

variable "sku" {
  type = string
}

variable "apg_subnet_name" {
  type = string
}

variable "apg_subnet_prefixes" {
  type = list(string)
}

variable "aci_subnet_name" {
  type = string
}

variable "aci_subnet_prefixes" {
  type = list(string)
}

variable "ip_address_type" {
  type = string
}

variable "ghtoken" {
  type = string
  sensitive = true
}