resource "azurerm_resource_provider_registration" "microsofthybridcompute" {
  name = "Microsoft.HybridCompute"
}

resource "azurerm_resource_provider_registration" "microsoftkubernetes" {
  name = "Microsoft.Kubernetes"
}

resource "azurerm_resource_provider_registration" "microsoftkubernetesconfiguration" {
  name = "Microsoft.KubernetesConfiguration"
}

resource "azurerm_resource_provider_registration" "microsoftextendedlocation" {
  name = "Microsoft.ExtendedLocation"
}

resource "azurerm_resource_group" "tf-arc-linux" {
  name     = format("%s%s",var.arc_resource_group_name,"-linux")
  location = var.location
  tags = {
    environment = "tf-arc-linux"
  }
}

resource "azurerm_resource_group" "tf-arc-windows" {
  name     = format("%s%s",var.arc_resource_group_name,"-windows")
  location = var.location
  tags = {
    environment = "work"
  }
}

resource "azurerm_resource_group" "tf-arc-kubernetes" {
  name     = format("%s%s",var.arc_resource_group_name,"-kubernetes")
  location = var.location
  tags = {
    environment = "work"
  }
}

resource "azurerm_log_analytics_workspace" "tf-arc-kubernetes" {
  name                = "acctest-01"
  location            = var.location
  resource_group_name = format("%s%s",var.arc_resource_group_name,"-kubernetes")
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azuread_application" "tf-arc" {
  display_name = "tf-arc"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "arc-onboarding" {
  application_id               = azuread_application.tf-arc.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  tags = ["arc"]
}

resource "azurerm_role_assignment" "sp-arc-linux-k8s" {
  scope              = azurerm_resource_group.tf-arc-kubernetes.id
  role_definition_name = "Kubernetes Cluster - Azure Arc Onboarding"
  principal_id       = azuread_service_principal.arc-onboarding.object_id
}

resource "azurerm_role_assignment" "sp-arc-linux-k8s-contributor" {
  scope              = azurerm_resource_group.tf-arc-kubernetes.id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.arc-onboarding.object_id
}

resource "azurerm_role_assignment" "sp-arc-linux-k8s-metrics" {
  scope              = azurerm_resource_group.tf-arc-kubernetes.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id       = azuread_service_principal.arc-onboarding.object_id
}

resource "azurerm_role_assignment" "sp-arc-linux-srv" {
  scope              = azurerm_resource_group.tf-arc-linux.id
  role_definition_name = "Azure Connected Machine Onboarding"
  principal_id       = azuread_service_principal.arc-onboarding.object_id
}

resource "azuread_service_principal_password" "tf-arc" {
  service_principal_id = azuread_service_principal.arc-onboarding.object_id
}

output "arc-sp-id" {
  description = "Azure Arc Onboarding Service Principal Id"
  value       = azuread_service_principal.arc-onboarding.object_id
  sensitive   = false
}

output "arc-sp-secret" {
  description = "Azure Arc Onboarding Service Principal Secret"
  value       = azuread_service_principal_password.tf-arc.value
  sensitive   = true
}

output "arc-loganalytics-workspace-id" {
  description = "Log Analytics Workspace for kubernetes arc"
  value       = azurerm_log_analytics_workspace.tf-arc-kubernetes.workspace_id
  sensitive   = false
}

output "arc-loganalytics-workspace-shared-key" {
  description = "Log Analytics Workspace Shared Key for kubernetes arc"
  value       = azurerm_log_analytics_workspace.tf-arc-kubernetes.primary_shared_key
  sensitive   = true
}