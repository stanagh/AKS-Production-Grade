output "sql_database_id" {
  description = "The ID of the SQL Database."
  value       = azurerm_mssql_database.sql_database.id
}

output "sql_database_name" {
  description = "The name of the SQL Database."
  value       = azurerm_mssql_database.sql_database.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server."
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "sql_server_admin_login" {
  description = "The administrator login name for the SQL Server."
  value       = azurerm_mssql_server.sql_server.administrator_login
}

output "sql_server_admin_password" {
  description = "The administrator password for the SQL Server."
  value       = azurerm_mssql_server.sql_server.administrator_login_password
}