resource "azurerm_resource_group" "tf-vmimages" {
  name     = var.customimages_resource_group_name
  location = var.location
  tags = {
    environment = "tf-home"
  }
}