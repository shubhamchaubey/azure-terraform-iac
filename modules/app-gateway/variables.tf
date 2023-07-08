variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "pip-id" {
  type = string
}

variable "private_aci_ip_address" {
  type = list(string)
}
variable "gateway_name" {
  type = string
}