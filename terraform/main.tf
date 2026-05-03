data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_name
}

data "http" "my_public_ip" {
  url = "https://icanhazip.com"
}

resource "random_password" "grafana_admin_password" {
  length  = 16
  special = true
}

resource "random_password" "sql_server_admin_password" {
  length  = 16
  special = true
}


module "kv" {
  source                    = "./modules/kv"
  key_vault_name            = "kv-${local.environment}-${local.location}-${local.platform}-${local.workload}-02"
  location                  = data.azurerm_resource_group.rg.location
  resource_group_name       = data.azurerm_resource_group.rg.name
  tags                      = local.tags
  grafana_admin_password    = random_password.grafana_admin_password.result
  sql_server_admin_password = random_password.sql_server_admin_password.result
  sql_server_fqdn           = module.sql.sql_server_fqdn
  sql_database_name         = module.sql.sql_database_name
  sql_server_admin_login    = module.sql.sql_server_admin_login
  principal_id              = data.azurerm_client_config.current.object_id
}

module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = "vnet-${local.environment}-${local.location}-${local.platform}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_name         = "snet-${local.environment}-${local.location}-${local.platform}-aks"
}

module "dns" {
  source              = "./modules/dns"
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.tags
}

module "role_assignments_kubelet" {
  source       = "./modules/role_assignment"
  principal_id = module.aks.kubelet_identity_object_id

  role_assignments = {
    acr_pull = {
      scope                = module.acr.acr_id
      role_definition_name = "AcrPull"
    }
  }
}

module "role_assignments_cert_manager" {
  source       = "./modules/role_assignment"
  principal_id = module.uami_cert_manager.principal_id

  role_assignments = {
    dns_zone_contributor = {
      scope                = module.dns.dns_zone_id
      role_definition_name = "DNS Zone Contributor"
    }
  }
}

module "role_assignments_external_dns" {
  source       = "./modules/role_assignment"
  principal_id = module.uami_external_dns.principal_id

  role_assignments = {
    dns_zone_contributor = {
      scope                = module.dns.dns_zone_id
      role_definition_name = "DNS Zone Contributor"
    }
  }
}

module "role_assignments_sql" {
  source         = "./modules/role_assignment"
  principal_id   = data.azurerm_client_config.current.object_id
  principal_type = "User"

  role_assignments = {
    sql_db_contributor = {
      scope                = module.sql.sql_database_id
      role_definition_name = "SQL DB Contributor"
    }
  }
}

module "role_assignments_grafana" {
  source       = "./modules/role_assignment"
  principal_id = module.uami_grafana.principal_id

  role_assignments = {
    key_vault_secrets_user = {
      scope                = module.kv.keyvault_id
      role_definition_name = "Key Vault Secrets User"
    }
  }
}

module "role_assignments_attendance_crm" {
  source       = "./modules/role_assignment"
  principal_id = module.uami_attendance_crm.principal_id

  role_assignments = {
    key_vault_secrets_user = {
      scope                = module.kv.keyvault_id
      role_definition_name = "Key Vault Secrets User"
    }
  }
}

module "uami_cert_manager" {
  source                    = "./modules/managed_identities"
  name                      = "uami-cert-manager-${local.environment}-${local.location}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  oidc_issuer_url           = module.aks.oidc_issuer_url
  service_account_namespace = "cert-manager"
  service_account_name      = "cert-manager"
}

module "uami_external_dns" {
  source                    = "./modules/managed_identities"
  name                      = "uami-external-dns-${local.environment}-${local.location}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  oidc_issuer_url           = module.aks.oidc_issuer_url
  service_account_namespace = "external-dns"
  service_account_name      = "external-dns"
}

module "uami_grafana" {
  source                    = "./modules/managed_identities"
  name                      = "uami-grafana-${local.environment}-${local.location}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  oidc_issuer_url           = module.aks.oidc_issuer_url
  service_account_namespace = "monitoring"
  service_account_name      = "kube-prometheus-stack-grafana"
}

module "uami_attendance_crm" {
  source                    = "./modules/managed_identities"
  name                      = "uami-attendance-crm-${local.environment}-${local.location}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  oidc_issuer_url           = module.aks.oidc_issuer_url
  service_account_namespace = "attendance-crm"
  service_account_name      = "attendance-crm"
}


module "sql" {
  source                        = "./modules/sql"
  sql_server_name               = "sql-${local.environment}-${local.location}-${local.platform}"
  sql_server_admin_password     = random_password.sql_server_admin_password.result
  my_personal_ip                = var.personal_ip_address != "" ? var.personal_ip_address : trimspace(data.http.my_public_ip.response_body)
  azure_administrator_object_id = data.azurerm_client_config.current.object_id
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  tags                          = local.tags
  aks_subnet_id                 = module.vnet.subnet_id

}

module "acr" {
  source              = "./modules/acr"
  acr_name            = "acr${local.environment}${local.location}${local.platform}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = local.tags
}

module "log" {
  source                        = "./modules/log"
  logs_analytics_workspace_name = "log-${local.environment}-${local.location}-${local.platform}"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  tags                          = local.tags
}

module "appi" {
  source                     = "./modules/appi"
  appi_name                  = "appi-${local.environment}-${local.location}-${local.platform}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  tags                       = local.tags
  log_analytics_workspace_id = module.log.log_analytics_workspace_id
  availability_url           = "https://attendance.attendanceappservice.online"
}

module "alert_rule" {
  source                     = "./modules/alert_rule"
  name                       = "alert-${local.environment}-${local.location}-${local.platform}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  alert_email                = var.email_address
  log_analytics_workspace_id = module.log.log_analytics_workspace_id
  app_insights_id            = module.appi.id
  tags                       = local.tags

  depends_on = [
    module.log,
    module.appi
  ]
}

module "aks" {
  source                     = "./modules/aks"
  aks_cluster_name           = "aks-${local.environment}-${local.location}-${local.workload}"
  dns_prefix                 = "aks${local.environment}${local.location}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  subnet_id                  = module.vnet.subnet_id
  tags                       = local.tags
  log_analytics_workspace_id = module.log.log_analytics_workspace_id
}

