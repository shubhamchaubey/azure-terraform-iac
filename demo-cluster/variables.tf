variable "vnet" {
  type = map(any)

  default = {
    vnet1 = {
        vnet-name = "vnet1"
        address_space = ["10.50.0.0/16"]
    }

    vnet2 = {
        vnet-name = "vnet1"
        address_space = ["10.51.0.0/16"]
    }
  }
}

variable "subnet" {
  type = map(any)

  default = {
    subnet1 = {
        name = "subnet1"
        address_prefixes = ["10.50.0.0/19"]
    }

    subnet2 = {
        name = "subnet2"
        address_prefixes = ["10.50.32.0/19"]
    }
  }
}