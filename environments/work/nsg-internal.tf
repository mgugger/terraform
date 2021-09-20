resource "azurerm_network_security_group" "internal" {
  name                = "nsg-internal"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_subnet_network_security_group_association" "internal" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.internal.id
}