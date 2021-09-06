provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "tf-sandbox" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "tf-sandbox"
  }
}