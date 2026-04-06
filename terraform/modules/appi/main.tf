resource "azurerm_application_insights" "appi" {
  name                = var.appi_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
  workspace_id        = var.log_analytics_workspace_id
  tags                = var.tags
}

resource "azurerm_application_insights_standard_web_test" "availability_test" {
  name                    = "${var.appi_name}-availability-test"
  location                = azurerm_application_insights.appi.location
  resource_group_name     = azurerm_application_insights.appi.resource_group_name
  application_insights_id = azurerm_application_insights.appi.id
  frequency               = var.frequency
  timeout                 = var.timeout
  enabled                 = var.enabled
  geo_locations           = var.geo_locations

  request {
    url = var.availability_url
  }

  validation_rules {
    expected_status_code = var.expected_http_status_code
  }

  tags = var.tags
}
