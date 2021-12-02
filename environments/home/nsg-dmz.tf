resource "azurerm_network_security_group" "dmz" {
  name                = "nsg-dmz"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
}

resource "azurerm_subnet_network_security_group_association" "dmz" {
  subnet_id                 = azurerm_subnet.dmz.id
  network_security_group_id = azurerm_network_security_group.dmz.id
}

resource "azurerm_network_security_rule" "dmzrules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.tf-connectivity.name
  network_security_group_name = azurerm_network_security_group.dmz.name
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

locals { 
  nsgrules = {  
    wireguard = {
      name                       = "wireguard-udp"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range    = "51820"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }

    dns = {
      name                       = "coredns-udp"
      priority                   = 1010
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range    = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }

    allow_vnet_inbound = {
      name                       = "allow_vnet_inbound"
      priority                   = 3500
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range    = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }

    # Allow SSH to Wireguard server from current ip only
    ssh = {
      name                       = "ssh"
      priority                   = 3000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "${chomp(data.http.myip.body)}/32"
      destination_address_prefix = "*"
    }

    deny_catchall = {
      name                       = "deny-catchall"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range    = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
  }
}