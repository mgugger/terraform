resource "azurerm_network_security_group" "windows" {
  name                = "nsg-windows"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_subnet_network_security_group_association" "windows" {
  subnet_id                 = azurerm_subnet.windows.id
  network_security_group_id = azurerm_network_security_group.windows.id
}