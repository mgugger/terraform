resource "azurerm_network_interface" "nic-wireguard" {
  name                = "nic-wireguard"
  location            = azurerm_resource_group.tf-connectivity.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dmz.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip-wireguard.id
  }
}

resource "azurerm_public_ip" "pip-wireguard" {
  name                = "pip-wireguard"
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  location            = azurerm_resource_group.tf-connectivity.location
  allocation_method   = "Static"
  domain_name_label = "mdghome"

  tags = {
    environment = "home"
    applicationRole = "wireguard"
  }
}

resource "azurerm_managed_disk" "wireguard-osdisk" {
  name = "vm-wireguard-osdisk"
  os_type              = "Linux"
  location = var.location
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  storage_account_type = "Premium_LRS"
  create_option = "Copy"
  source_resource_id = var.vm_snapshot_resource_id
  disk_size_gb = "4"

  tags = {
    environment = "home"
    applicationRole = "wireguard"
  }
}

## Wireguard VM
resource "azurerm_virtual_machine" "vm-wireguard" {
  name                  = "vm-wireguard"
  location              = var.location
  resource_group_name   = azurerm_resource_group.tf-connectivity.name
  vm_size               = "Standard_B1ls"
  network_interface_ids = [
    azurerm_network_interface.nic-wireguard.id,
  ]

  storage_os_disk {
    name              = "vm-wireguard-osdisk"
    os_type = "linux"
    managed_disk_id   = "${resource.azurerm_managed_disk.wireguard-osdisk.id}"
    create_option     = "Attach"
  }

  tags = {
    environment = "home"
    applicationRole = "wireguard"
    wireguard_ip = "192.168.8.0/32"
  }
}