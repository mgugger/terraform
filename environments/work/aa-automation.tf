resource "azurerm_resource_group" "tf-automation" {
  name     = "tf-automation"
  location            = azurerm_resource_group.tf-connectivity.location
}

resource "azurerm_automation_account" "aa-arc" {
  name                = "aa-arc"
  location            = azurerm_resource_group.tf-automation.location
  resource_group_name = azurerm_resource_group.tf-automation.name

  sku_name = "Basic"

  tags = {
    environment = "tf-automation"
  }
}

resource "azurerm_log_analytics_solution" "law_solution_updates" {
  resource_group_name   = azurerm_resource_group.tf-automation.name
  location              = azurerm_resource_group.tf-automation.location

  solution_name         = "Updates"
  workspace_resource_id = azurerm_log_analytics_workspace.law-updates.id
  workspace_name        = "${element(split("/", azurerm_log_analytics_workspace.law-updates.id), length(split("/", azurerm_log_analytics_workspace.law-updates.id)) - 1)}"
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}


resource "azurerm_log_analytics_workspace" "law-updates" {
  name                = "aa-arc-workspace"
  location            = azurerm_resource_group.tf-automation.location
  resource_group_name = azurerm_resource_group.tf-automation.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_linked_service" "law-link" {
  resource_group_name = azurerm_resource_group.tf-automation.name
  workspace_id        = azurerm_log_analytics_workspace.law-updates.id
  read_access_id      = azurerm_automation_account.aa-arc.id
}