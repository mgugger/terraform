resource "azurerm_resource_group" "tf-connectivity" {
  name     = var.connectivity_resource_group_name
  location = var.location
  tags = {
    environment = "tf-connectivity"
  }
}

resource "azurerm_virtual_network" "vnet-azure" {
  name                = "vnet-connectivity"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  address_space       = ["10.0.172.0/24"]
  #dns_servers         = ["10.0.172.29", "10.0.172.30"]

  tags = {
    environment = "tf-connectivity"
  }
}

resource "azurerm_subnet" "dmz" {
  name                 = "dmz"
  virtual_network_name = azurerm_virtual_network.vnet-azure.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.172.0/27"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.vnet-azure.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes = ["10.0.172.32/27"]
}

## Free Ranges
# "10.0.172.64/27"
# "10.0.172.96/27"
# "10.0.172.128/27"
# "10.0.172.160/27"
# "10.0.172.192/27"