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

resource "bigip_as3"  "tenant01_app1" {
   as3_json = "${file("app1.json")}"
}