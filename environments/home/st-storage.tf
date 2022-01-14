resource "azurerm_resource_group" "st-backup" {
  name     = var.storage_resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "vm-images" {
  name                     = "mdgvmimages"
  resource_group_name      = azurerm_resource_group.st-backup.name
  location                 = azurerm_resource_group.st-backup.location
  account_kind = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Cool"
  min_tls_version = "TLS1_2"
  allow_blob_public_access = false
  shared_access_key_enabled = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["${chomp(data.http.myip.body)}"]
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "home"
  }
}

resource "azurerm_role_assignment" "vm-images-data-contributor-role" {
  scope                = azurerm_storage_account.vm-images.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_container" "archlinux" {
  depends_on = [azurerm_role_assignment.vm-images-data-contributor-role]
  name                  = "archlinux"
  storage_account_name  = azurerm_storage_account.vm-images.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "restic-backup" {
  name                     = "mdgresticbackup"
  resource_group_name      = azurerm_resource_group.st-backup.name
  location                 = azurerm_resource_group.st-backup.location
  account_kind = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier = "Cool"
  min_tls_version = "TLS1_2"
  allow_blob_public_access = false
  shared_access_key_enabled = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["${chomp(data.http.myip.body)}"]
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "home"
  }
}

resource "azurerm_role_assignment" "restic-backup-data-contributor-role" {
  scope                = azurerm_storage_account.restic-backup.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_container" "Music" {
  depends_on = [azurerm_role_assignment.restic-backup-data-contributor-role]
  name                  = "music"
  storage_account_name  = azurerm_storage_account.restic-backup.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "Pictures" {
  depends_on = [azurerm_role_assignment.restic-backup-data-contributor-role]
  name                  = "pictures"
  storage_account_name  = azurerm_storage_account.restic-backup.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "Documents" {
  depends_on = [azurerm_role_assignment.restic-backup-data-contributor-role]
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.restic-backup.name
  container_access_type = "private"
}