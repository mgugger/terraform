resource "azurerm_resource_group" "tf-storage" {
  name     = "tf-storage"
  location = var.location
}

resource "azurerm_storage_account" "st-storage" {
  name                     = "mdgworkfilestorage"
  resource_group_name      = azurerm_resource_group.tf-storage.name
  location                 = azurerm_resource_group.tf-storage.location
  account_kind              = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Hot"
  min_tls_version = "TLS1_2"
  allow_blob_public_access = false
  shared_access_key_enabled = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "work"
  }
}

resource "azurerm_private_endpoint" "st-storage" {
  name                = "st-storage"
  location            = azurerm_resource_group.tf-storage.location
  resource_group_name = azurerm_resource_group.tf-storage.name
  subnet_id           = azurerm_subnet.internal.id

  private_service_connection {
    name = "st-storage-pe"
    is_manual_connection = false
    subresource_names = ["file"]
    private_connection_resource_id = azurerm_storage_account.st-storage.id
  }
}

resource "azurerm_private_dns_a_record" "st-storage" {
  name                = azurerm_storage_account.st-storage.name
  zone_name           = azurerm_private_dns_zone.private-storage-file.name
  resource_group_name = azurerm_resource_group.tf-connectivity.name
  ttl                 = 300
  records             = [ azurerm_private_endpoint.st-storage.private_service_connection[0].private_ip_address ]
}

resource "azurerm_role_assignment" "aks-tf-storage-role" {
  scope                            = azurerm_resource_group.tf-storage.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  skip_service_principal_aad_check = true
}