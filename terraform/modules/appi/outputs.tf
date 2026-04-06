output "instrumentation_key" {
  description = "The instrumentation key of the Application Insights resource."
  value       = azurerm_application_insights.appi.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "The connection string of the Application Insights resource."
  value       = azurerm_application_insights.appi.connection_string
  sensitive   = true
}

output "app_id" {
  description = "The app ID of the Application Insights resource."
  value       = azurerm_application_insights.appi.app_id
}

output "id" {
  description = "The ID of the Application Insights resource."
  value       = azurerm_application_insights.appi.id
}