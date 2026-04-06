locals {
  secrets = {
    grafana-admin-password    = var.grafana_admin_password
    sql-server-admin-password = var.sql_server_admin_password
    sql-connection-string     = "data source=${var.sql_server_fqdn};initial catalog=${var.sql_database_name};user id=${var.sql_server_admin_login};password=${var.sql_server_admin_password};TrustServerCertificate=True;"
  }
}