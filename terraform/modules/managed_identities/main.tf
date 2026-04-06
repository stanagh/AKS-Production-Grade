resource "azurerm_user_assigned_identity" "uami" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "fed_id_cred" {
  count = var.federated_identity_credential ? 1 : 0

  name      = "${var.name}-fed-id-cred"
  audience  = ["api://AzureADTokenExchange"]
  issuer    = var.oidc_issuer_url
  parent_id = azurerm_user_assigned_identity.uami.id
  subject   = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
}