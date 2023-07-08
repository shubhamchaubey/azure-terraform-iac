variable "vnet_name" {
  type = string
}

variable "vnet_location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
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

variable "rg_name" {
  type = string
}