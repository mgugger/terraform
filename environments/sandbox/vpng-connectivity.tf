resource "azurerm_public_ip" "pip-vpng" {
  name                = "pip-vpng"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpng-connectivity" {
  name                = "vpng-sandbox"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-vpng.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }

  vpn_client_configuration {
    address_space = ["10.0.2.0/24"]

    root_certificate {
      name = "vpnca"
      public_cert_data = var.vpn_root_cert
    }
  }
}

