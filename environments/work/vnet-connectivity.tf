resource "azurerm_resource_group" "tf-connectivity" {
  name     = var.connectivity_resource_group_name
  location = var.location
  tags = {
    environment = "work"
  }
}

resource "azurerm_virtual_network" "sandbox" {
  name                = "vnet-sandbox"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  address_space       = ["10.0.235.0/24"]
  #dns_servers         = ["10.0.235.29", "10.0.235.30"]

  tags = {
    environment = "work"
  }
}

resource "azurerm_subnet" "dmz" {
  name                 = "dmz"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  address_prefixes     = ["10.0.235.0/27"]
  service_endpoints                              = [
   "Microsoft.Storage"
  ]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.sandbox.name
  resource_group_name  = azurerm_resource_group.tf-connectivity.name
  enforce_private_link_endpoint_network_policies = true
  address_prefixes     = ["10.0.235.32/27"]
  service_endpoints                              = [
   "Microsoft.Sql",
   "Microsoft.Storage"
  ]
}

resource "azurerm_subnet" "aks" {
  name                                           = "aks"
  enforce_private_link_endpoint_network_policies = true
  virtual_network_name                           = azurerm_virtual_network.sandbox.name
  resource_group_name                            = azurerm_resource_group.tf-connectivity.name
  address_prefixes                               = ["10.0.235.64/27"]
  service_endpoints                              = [
   "Microsoft.Storage"
  ]
}

resource "azurerm_subnet" "postgresql" {
  name                                           = "postgresql"
  enforce_private_link_endpoint_network_policies = true
  virtual_network_name                           = azurerm_virtual_network.sandbox.name
  resource_group_name                            = azurerm_resource_group.tf-connectivity.name
  address_prefixes                               = ["10.0.235.96/27"]
  service_endpoints                              = [ "Microsoft.Storage"]
  delegation {
    name = "dlg-Microsoft.DBforPostgreSQL-flexibleServers"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
    }
  }
}

## Free Ranges in 10.0.235.0/24
# "10.0.235.128/27"
# "10.0.235.160/27"
# "10.0.235.192/27"
