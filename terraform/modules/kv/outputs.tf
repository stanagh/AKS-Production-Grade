output "key_vault_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.keyvault.name

}

output "keyvault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.keyvault.id
}

output "keyvault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.keyvault.vault_uri
}

output "keyvault_secrets_values" {
  description = "A map of the secret values stored in the Key Vault, where the key is the name of the secret and the value is the value of the secret."
  value = {
    for key, secret in azurerm_key_vault_secret.secrets :
    key => secret.value
  }
  sensitive = true
}
