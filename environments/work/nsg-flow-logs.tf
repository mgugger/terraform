resource "azurerm_network_watcher" "flowlogs" {
  name                = "tfflowlogs"
  location            = azurerm_resource_group.tf-security.location
  resource_group_name = azurerm_resource_group.tf-security.name
}

resource "azurerm_storage_account" "tfflowlogs" {
  name                = "tfflowlogs"
  resource_group_name = azurerm_resource_group.tf-security.name
  location            = azurerm_resource_group.tf-security.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_log_analytics_workspace" "flowlogslaw" {
  name                = "flowlogslaw"
  location            = azurerm_resource_group.tf-security.location
  resource_group_name = azurerm_resource_group.tf-security.name
  sku                 = "PerGB2018"
}

resource "azurerm_network_watcher_flow_log" "flowlogsaks" {
  network_watcher_name = azurerm_network_watcher.flowlogs.name
  resource_group_name  = azurerm_resource_group.tf-security.name

  network_security_group_id = azurerm_network_security_group.aks.id
  storage_account_id        = azurerm_storage_account.tfflowlogs.id
  enabled                   = true

  version = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.flowlogslaw.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.flowlogslaw.location
    workspace_resource_id = azurerm_log_analytics_workspace.flowlogslaw.id
    interval_in_minutes   = 10
  }
}

resource "azurerm_network_watcher_flow_log" "flowlogsinternal" {
  network_watcher_name = azurerm_network_watcher.flowlogs.name
  resource_group_name  = azurerm_resource_group.tf-security.name

  network_security_group_id = azurerm_network_security_group.internal.id
  storage_account_id        = azurerm_storage_account.tfflowlogs.id
  enabled                   = true

  version = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.flowlogslaw.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.flowlogslaw.location
    workspace_resource_id = azurerm_log_analytics_workspace.flowlogslaw.id
    interval_in_minutes   = 10
  }
}

resource "azurerm_network_watcher_flow_log" "flowlogsdmz" {
  network_watcher_name = azurerm_network_watcher.flowlogs.name
  resource_group_name  = azurerm_resource_group.tf-security.name

  network_security_group_id = azurerm_network_security_group.dmz.id
  storage_account_id        = azurerm_storage_account.tfflowlogs.id
  enabled                   = true

  version = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.flowlogslaw.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.flowlogslaw.location
    workspace_resource_id = azurerm_log_analytics_workspace.flowlogslaw.id
    interval_in_minutes   = 10
  }
}