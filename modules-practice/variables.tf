variable "rg-name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet-address_space" {
  type = list(string)
}

variable "vnet_location" {
  type = string
}

variable "pub_subnet_name" {
  type = string
}

variable "pub_subnet_prefix" {
  type = list(string)
}

variable "private_subnet_name" {
  type = string
}

variable "private_subnet_prefix" {
  type = list(string)
}

variable "vmname" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "os_disk_type" {
  type = string
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}