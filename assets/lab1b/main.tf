
terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}

provider "bigip" {
    address = var.address
    username = var.username
    password = var.password
}