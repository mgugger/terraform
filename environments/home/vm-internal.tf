resource "azurerm_resource_group" "tf-vms" {
  name     = var.vms_resource_group_name
  location = var.location
}

resource "azurerm_network_interface" "nic-server1" {
  name                = "server1-nic"
  location            = azurerm_resource_group.tf-vms.location
  resource_group_name = azurerm_resource_group.tf-vms.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "server1-osdisk" {
  name = "vm-server1-osdisk"
  os_type              = "Linux"
  location = var.location
  resource_group_name = azurerm_resource_group.tf-vms.name
  storage_account_type = "Premium_LRS"
  create_option = "Copy"
  source_resource_id = var.vm_snapshot_resource_id
  disk_size_gb = "16"

  tags = {
    environment = "home"
  }
}

resource "azurerm_virtual_machine" "vm-server1" {
  name                  = "vm-server1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.tf-vms.name
  vm_size               = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.nic-server1.id,
  ]

  storage_os_disk {
    name              = "vm-server1-osdisk"
    os_type = "linux"
    managed_disk_id   = "${resource.azurerm_managed_disk.server1-osdisk.id}"
    create_option     = "Attach"
  }

  tags = {
    environment = "home"
    applicationRole = "devops"
    wireguard_ip = "192.168.8.5/32"
  }
}