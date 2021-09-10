resource "azurerm_resource_group" "tf-storage" {
  name     = var.storage_resource_group_name
  location = var.location
  tags = {
    environment = "tf-storage"
  }
}