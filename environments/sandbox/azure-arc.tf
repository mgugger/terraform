resource "azurerm_resource_provider_registration" "microsofthybridcompute" {
  name = "Microsoft.HybridCompute"
}

resource "azurerm_resource_provider_registration" "microsoftkubernetes" {
  name = "Microsoft.Kubernetes"
}

resource "azurerm_resource_provider_registration" "microsoftkubernetesconfiguration" {
  name = "Microsoft.KubernetesConfiguration"
}

resource "azurerm_resource_provider_registration" "microsoftkubernetesconfiguration" {
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
    environment = "tf-arc-windows"
  }
}

resource "azurerm_resource_group" "tf-arc-kubernetes" {
  name     = format("%s%s",var.arc_resource_group_name,"-kubernetes")
  location = var.location
  tags = {
    environment = "tf-arc-kubernetes"
  }
}

data "azuread_client_config" "current" {}

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
  scope              = azurerm_resource_group.tf-arc-linux.id
  #role_definition_id = "34e09817-6cbe-4d01-b1a2-e0eac5743d41" # Kubernetes Cluster - Azure Arc Onboarding
  role_definition_name = "Kubernetes Cluster - Azure Arc Onboarding"
  principal_id       = azuread_service_principal.arc-onboarding.object_id
}

resource "azurerm_role_assignment" "sp-arc-linux-srv" {
  scope              = azurerm_resource_group.tf-arc-linux.id
  #role_definition_id = "b64e21ea-ac4e-4cdf-9dc9-5b892992bee7" # Azure Connected Machine Onboarding
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
