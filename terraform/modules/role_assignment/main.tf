resource "azurerm_role_assignment" "role_assignments" {
  for_each = var.role_assignments

  scope                = each.value.scope
  principal_id         = var.principal_id
  role_definition_name = each.value.role_definition_name

  skip_service_principal_aad_check = var.principal_type == "ServicePrincipal" ? true : false
}