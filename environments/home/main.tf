provider "azurerm" {
  storage_use_azuread = true
  features {}
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "http" {
}

terraform {
  backend "azurerm" {}
}

data "azuread_client_config" "current" {}