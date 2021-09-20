provider "azurerm" {
  storage_use_azuread = true
  features {}
}

provider "http" {
}

terraform {
  backend "azurerm" {}
}

data "azuread_client_config" "current" {}