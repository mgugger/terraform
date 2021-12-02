resource "azuread_application" "ansible" {
  display_name = "ansible"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "ansible" {
  application_id               = azuread_application.ansible.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "ansible-connectivity" {
  scope              = azurerm_resource_group.tf-connectivity.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id       = azuread_service_principal.ansible.object_id
}

resource "azurerm_role_assignment" "ansible-vms" {
  scope              = azurerm_resource_group.tf-vms.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id       = azuread_service_principal.ansible.object_id
}

resource "azuread_service_principal_password" "ansible" {
  service_principal_id = azuread_service_principal.ansible.object_id
}

output "sp-ansible-id" {
  description = "Azure Arc Onboarding Service Principal Id"
  value       = azuread_service_principal.ansible.object_id
  sensitive   = false
}

output "sp-ansible-secret" {
  description = "Azure Arc Onboarding Service Principal Secret"
  value       = azuread_service_principal_password.ansible.value
  sensitive   = true
}