resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                              = var.aks_cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.dns_prefix
  tags                              = var.tags
  role_based_access_control_enabled = var.role_based_access_control_enabled

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.node_sku
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = var.identity_type
  }
  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  key_vault_secrets_provider { 
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}

# resource "azurerm_monitor_diagnostic_setting" "aks" {
#   name                       = var.aks_diagnostic_setting_name
#   target_resource_id         = azurerm_kubernetes_cluster.aks_cluster.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   dynamic "enabled_log" {
#     for_each = local.aks_log_categories
#     content {
#       category = enabled_log.value
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true
#   }
# }

