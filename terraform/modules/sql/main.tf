data "http" "my_public_ip" {
  url = "https://icanhazip.com"
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_admin_login
  administrator_login_password = var.sql_server_admin_password
  tags                         = var.tags

  azuread_administrator {
    login_username = var.azure_administrator_login
    object_id      = var.azure_administrator_object_id
  }
}

resource "azurerm_mssql_database" "sql_database" {
  name         = "${var.sql_server_name}-db"
  server_id    = azurerm_mssql_server.sql_server.id
  collation    = var.sql_database_collation
  license_type = var.sql_database_license_type
  max_size_gb  = var.max_size_gb
  sku_name     = var.sku_name
  enclave_type = var.sql_database_enclave_type
  tags         = var.tags

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false #to be changed to true after testing

  }
}

resource "azurerm_mssql_firewall_rule" "allow_local_machine" {
  name             = "AllowLocalMachine"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = local.my_public_ip
  end_ip_address   = local.my_public_ip
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "AllowAllAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = var.start_ip_address
  end_ip_address   = var.end_ip_address
}