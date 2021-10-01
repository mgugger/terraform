resource "azurerm_resource_group" "tf-k3s" {
  name     = var.k3s_resource_group_name
  location = var.location
}

# resource "azurerm_network_interface" "nic-k3s-server" {
#   name                = "nic-k3s-server"
#   location            = azurerm_resource_group.tf-k3s.location
#   resource_group_name = azurerm_resource_group.tf-k3s.name
#   enable_ip_forwarding = true

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.internal.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_managed_disk" "k3s-server-osdisk" {
#   name = "vm-k3s-server-osdisk"
#   os_type              = "Linux"
#   location = var.location
#   resource_group_name = azurerm_resource_group.tf-k3s.name
#   storage_account_type = "Premium_LRS"
#   create_option = "Copy"
#   source_resource_id = var.vm_snapshot_resource_id
#   disk_size_gb = "4"

#   tags = {
#     environment = "home"
#     applicationRole = "k3s-server"
#   }
# }

# ## Wireguard VM
# resource "azurerm_virtual_machine" "vm-k3s-server" {
#   name                  = "vm-k3s-server"
#   location              = var.location
#   resource_group_name   = azurerm_resource_group.tf-k3s.name
#   vm_size               = "Standard_B1ls"
#   network_interface_ids = [
#     azurerm_network_interface.nic-k3s-server.id,
#   ]

#   storage_os_disk {
#     name              = "vm-k3s-server-osdisk"
#     os_type = "linux"
#     managed_disk_id   = "${resource.azurerm_managed_disk.k3s-server-osdisk.id}"
#     create_option     = "Attach"
#   }

#   tags = {
#     environment = "home"
#     applicationRole = "k3s-server"
#     wireguard_ip = "192.168.8.4/32"
#   }
# }

resource "azurerm_network_interface" "nic-k3s-agent1" {
  name                = "nic-k3s-agent1"
  location            = azurerm_resource_group.tf-k3s.location
  resource_group_name = azurerm_resource_group.tf-k3s.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "k3s-agent1-osdisk" {
  name = "vm-k3s-agent1-osdisk"
  os_type              = "Linux"
  location = var.location
  resource_group_name = azurerm_resource_group.tf-k3s.name
  storage_account_type = "Premium_LRS"
  create_option = "Copy"
  source_resource_id = var.vm_snapshot_resource_id
  disk_size_gb = "4"

  tags = {
    environment = "home"
    applicationRole = "k3s-agent1"
  }
}

## Wireguard VM
resource "azurerm_virtual_machine" "vm-k3s-agent1" {
  name                  = "vm-k3s-agent1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.tf-k3s.name
  vm_size               = "Standard_B2s"
  network_interface_ids = [
    azurerm_network_interface.nic-k3s-agent1.id,
  ]

  storage_os_disk {
    name              = "vm-k3s-agent1-osdisk"
    os_type = "linux"
    managed_disk_id   = "${resource.azurerm_managed_disk.k3s-agent1-osdisk.id}"
    create_option     = "Attach"
  }

  tags = {
    environment = "home"
    applicationRole = "k3s-agent"
    wireguard_ip = "192.168.8.5/32"
  }
}