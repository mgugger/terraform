resource "azurerm_private_dns_zone" "private-storage-blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_private_dns_zone" "private-storage-file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private-storage-blob" {
  name                  = azurerm_private_dns_zone.private-storage-blob.name
  resource_group_name   = azurerm_resource_group.tf-connectivity.name
  private_dns_zone_name = azurerm_private_dns_zone.private-storage-blob.name
  virtual_network_id    = azurerm_virtual_network.sandbox.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private-storage-file" {
  name                  = azurerm_private_dns_zone.private-storage-file.name
  resource_group_name   = azurerm_resource_group.tf-connectivity.name
  private_dns_zone_name = azurerm_private_dns_zone.private-storage-file.name
  virtual_network_id    = azurerm_virtual_network.sandbox.id
}