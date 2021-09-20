resource "azurerm_resource_group" "tf-k3s" {
  name     = var.k3s_resource_group_name
  location = var.location
  tags = {
    environment = "work"
  }
}

## Server ##
resource "azurerm_network_interface" "nic-k3s-server1" {
  name                = "nic-k3s-server1"
  location            = azurerm_resource_group.tf-k3s.location
  resource_group_name = azurerm_resource_group.tf-k3s.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-k3s-server1" {
  name                = "vm-k3s-server1"
  resource_group_name = azurerm_resource_group.tf-k3s.name
  location            = azurerm_resource_group.tf-k3s.location
  size                = "Standard_B2s"
  admin_username      =  var.vm_username
  network_interface_ids = [
    azurerm_network_interface.nic-k3s-server1.id,
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
    zone = "internal"
    applicationRole = "k3s"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "k3s-server1-vm-schedule" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm-k3s-server1.id
  location           = azurerm_resource_group.tf-k3s.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "Central European Standard Time"

  notification_settings {
    enabled         = false
    time_in_minutes = "15"
  }
}

## Worker 1 ##
resource "azurerm_network_interface" "nic-k3s-worker1" {
  name                = "nic-k3s-worker1"
  location            = azurerm_resource_group.tf-k3s.location
  resource_group_name = azurerm_resource_group.tf-k3s.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-k3s-worker1" {
  name                = "vm-k3s-worker1"
  resource_group_name = azurerm_resource_group.tf-k3s.name
  location            = azurerm_resource_group.tf-k3s.location
  size                = "Standard_B4ms"
  admin_username      =  var.vm_username
  network_interface_ids = [
    azurerm_network_interface.nic-k3s-worker1.id,
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
    zone = "internal"
    applicationRole = "k3s"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "k3s-worker1-vm-schedule" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm-k3s-worker1.id
  location           = azurerm_resource_group.tf-k3s.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "Central European Standard Time"

  notification_settings {
    enabled         = false
    time_in_minutes = "15"
  }
}
