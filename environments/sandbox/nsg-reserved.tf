resource "azurerm_network_security_group" "reserved" {
  name                = "nsg-reserved"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_subnet_network_security_group_association" "reserved" {
  subnet_id                 = azurerm_subnet.reserved.id
  network_security_group_id = azurerm_network_security_group.reserved.id
}