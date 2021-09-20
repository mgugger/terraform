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
  domain_name_label = "mdgwgsandbox"

  tags = {
    environment = "sandbox"
    applicationRole = "wireguard"
  }
}

resource "azurerm_linux_virtual_machine" "vm-wireguard" {
  name                = "vm-wireguard"
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  location            = azurerm_resource_group.tf-connectivity.location
  size                = "Standard_B1ls"
  admin_username      =  var.vm_username
  network_interface_ids = [
    azurerm_network_interface.nic-wireguard.id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb = "32"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts-gen2"
    version   = "20.04.202109140"
  }

  tags = {
    environment = "work"
    zone = "dmz"
    applicationRole = "wireguard"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "wireguard-vm-schedule" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm-wireguard.id
  location           = azurerm_resource_group.tf-connectivity.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "Central European Standard Time"

  notification_settings {
    enabled         = false
    time_in_minutes = "15"
  }
}
