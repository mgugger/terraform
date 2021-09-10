resource "azurerm_network_security_group" "linux" {
  name                = "nsg-linux"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_subnet_network_security_group_association" "linux" {
  subnet_id                 = azurerm_subnet.linux.id
  network_security_group_id = azurerm_network_security_group.linux.id
}