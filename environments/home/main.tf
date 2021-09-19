provider "azurerm" {
  features {}
}

provider "http" {
}

terraform {
  backend "azurerm" {}
}