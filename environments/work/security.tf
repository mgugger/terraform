resource "azurerm_resource_group" "tf-security" {
  name     = "tf-security"
  location = var.location
}

resource "azurerm_key_vault" "keyvault" {
  name                       = "mdgcorpkeyvault"
  location                   = azurerm_resource_group.tf-security.location
  resource_group_name        = azurerm_resource_group.tf-security.name
  tenant_id                  = data.azuread_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azuread_client_config.current.tenant_id
    object_id = data.azuread_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
      "purge",
      "recover"
    ]

    secret_permissions = [
      "set",
    ]
  }
}