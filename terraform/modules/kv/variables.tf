variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the Key Vault."
  type        = map(string)
  default     = {}
}

variable "soft_delete_retention_days" {
  description = "The number of days that the Key Vault will be retained after deletion."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Specifies whether purge protection is enabled for the Key Vault."
  type        = bool
  default     = false
}

variable "rbac_authorization_enabled" {
  description = "Specifies whether RBAC authorization is enabled for the Key Vault."
  type        = bool
  default     = true
}

variable "sku_name" {
  description = "The SKU name of the Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
  default     = "standard"
}

variable "key_vault_secret_grafana" {
  description = "The name of the secret to store the Grafana admin password."
  type        = string
  default     = "grafana-admin-password"
}

variable "grafana_admin_password" {
  description = "The value of the Grafana admin password to be stored in the Key Vault secret."
  type        = string
}

variable "principal_id" {
  description = "The principal ID of the user or service principal to which the role assignment will be granted."
  type        = string
}

variable "role_definition_name" {
  description = "The name of the role definition to assign to the principal. Possible values are 'Key Vault Secrets User', 'Key Vault Secrets Officer', 'Key Vault Contributor', etc."
  type        = string
  default     = "Key Vault Secrets Officer"
}

variable "sql_server_admin_password" {
  description = "The value of the SQL admin password to be stored in the Key Vault secret."
  type        = string
}

variable "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server."
  type        = string
}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string
}

variable "sql_server_admin_login" {
  description = "The administrator login name for the SQL Server."
  type        = string
}

