resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.logs_analytics_workspace_name
  resource_group_name = var.resource_group_name
  sku                 = var.sku_name
  location            = var.location
  tags                = var.tags
  retention_in_days   = var.retention_in_days

}