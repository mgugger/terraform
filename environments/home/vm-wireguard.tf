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
  allocation_method   = "Dynamic"
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


# Ubuntu VM for creating archlinux vm image
# resource "azurerm_linux_virtual_machine" "vm-wireguard" {
#   name                = "vm-wireguard"
#   resource_group_name = azurerm_resource_group.tf-connectivity.name
#   location            = azurerm_resource_group.tf-connectivity.location
#   size                = "Standard_B1ls"
#   admin_username      =  var.vm_username
#   network_interface_ids = [
#     azurerm_network_interface.nic-wireguard.id,
#   ]

#   admin_ssh_key {
#     username   = var.vm_username
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"
#     disk_size_gb = "32"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal-daily"
#     sku       = "20_04-daily-lts-gen2"
#     version   = "20.04.202109140"
#   }

#   tags = {
#     zone = "dmz"
#     applicationRole = "wireguard"
#   }
# }

# resource "azurerm_dev_test_global_vm_shutdown_schedule" "wireguard-vm-schedule" {
#   virtual_machine_id = azurerm_virtual_machine.vm-wireguard.id
#   location           = azurerm_resource_group.tf-connectivity.location
#   enabled            = true

#   daily_recurrence_time = "2300"
#   timezone              = "Central European Standard Time"

#   notification_settings {
#     enabled         = false
#     time_in_minutes = "15"
#   }
# }