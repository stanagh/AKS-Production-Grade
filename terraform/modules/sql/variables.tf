variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
}


variable "resource_group_name" {
  description = "The name of the resource group in which to create the SQL Server."
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the SQL Server."
  type        = string
}

variable "sql_server_version" {
  description = "The version of the SQL Server."
  type        = string
  default     = "12.0"
}

variable "sql_server_admin_login" {
  description = "The administrator login for the SQL Server."
  type        = string
  default     = "saadmin"
}

variable "sql_server_admin_password" {
  description = "The administrator login password for the SQL Server."
  type        = string
  sensitive   = true
}

variable "azure_administrator_login" {
  description = "The login name of the Azure AD administrator for the SQL Server."
  type        = string
  default     = "saaghara@outlook.com"
}

variable "azure_administrator_object_id" {
  description = "The object ID of the Azure AD administrator for the SQL Server."
  type        = string
}

variable "sql_database_collation" {
  description = "The collation of the SQL Database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sql_database_license_type" {
  description = "The license type of the SQL Database."
  type        = string
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  description = "The maximum size of the SQL Database in GB."
  type        = number
  default     = 2
}

variable "sku_name" {
  description = "The SKU name of the SQL Database."
  type        = string
  default     = "S0"
}

variable "sql_database_enclave_type" {
  description = "The enclave type of the SQL Database."
  type        = string
  default     = "VBS"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "start_ip_address" {
  description = "The starting IP address of the firewall rule to allow access to Azure services."
  type        = string
  default     = "0.0.0.0"
}

variable "end_ip_address" {
  description = "The ending IP address of the firewall rule to allow access to Azure services."
  type        = string
  default     = "0.0.0.0"
}