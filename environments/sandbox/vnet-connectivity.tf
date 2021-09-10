resource "azurerm_resource_group" "tf-connectivity" {
  name     = var.connectivity_resource_group_name
  location = var.location
  tags = {
    environment = "tf-connectivity"
  }
}

resource "azurerm_virtual_network" "sandbox" {
  name                = "vnet-sandbox"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  address_space       = ["10.0.0.0/23"]
  dns_servers         = ["10.0.0.30", "10.0.0.29"]

  tags = {
    environment = "tf-connectivity"
  }
}

resource "azurerm_subnet" "reserved" {
  name                 = "reserved"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "windows" {
  name                 = "windows"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.32/27"]
}

resource "azurerm_subnet" "linux" {
  name                 = "linux"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.64/27"]
}

resource "azurerm_subnet" "data" {
  name                 = "data"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.96/27"]
}

resource "azurerm_subnet" "client" {
  name                 = "client"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.128/27"]
}

resource "azurerm_subnet" "dmz" {
  name                 = "dmz"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.160/27"]
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.0.192/27"]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.1.0/24"]
}

