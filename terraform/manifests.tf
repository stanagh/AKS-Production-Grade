resource "kubectl_manifest" "cert_manager_service_account" {
  yaml_body = templatefile("${path.module}/k8s/cert-manager-serviceaccount.yml", {
    MANAGED_IDENTITY_CLIENT_ID = module.uami_cert_manager.client_id
  })

  force_conflicts   = true
  server_side_apply = true

  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_secret" "external_dns_azure_config" {
  metadata {
    name      = "external-dns-azure-config"
    namespace = "external-dns"
  }


  data = {
    "azure.json" = jsonencode({
      tenantId                     = data.azurerm_client_config.current.tenant_id
      subscriptionId               = data.azurerm_client_config.current.subscription_id
      resourceGroup                = data.azurerm_resource_group.rg.name
      useWorkloadIdentityExtension = true
      useManagedIdentityExtension  = false
      userAssignedIdentityID       = module.uami_external_dns.client_id
    })
  }

  depends_on = [module.aks,
  kubernetes_namespace.external_dns]
}

resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  yaml_body = templatefile("${path.module}/k8s/cert-manager-clusterissuer.yml", {
    EMAIL_ADDRESS              = var.email_address
    AZURE_SUBSCRIPTION_ID      = data.azurerm_client_config.current.subscription_id
    RESOURCE_GROUP_NAME        = data.azurerm_resource_group.rg.name
    HOSTED_ZONE_NAME           = var.hosted_zone_name
    MANAGED_IDENTITY_CLIENT_ID = module.uami_cert_manager.client_id
    AZURE_TENANT_ID            = data.azurerm_client_config.current.tenant_id
  })

  force_conflicts   = true
  server_side_apply = true

  depends_on = [kubectl_manifest.cert_manager_service_account]
}

resource "kubectl_manifest" "external_dns_service_account" {
  yaml_body = templatefile("${path.module}/k8s/external-dns-serviceaccount.yml", {
    EXTERNAL_DNS_CLIENT_ID = module.uami_external_dns.client_id
  })

  force_conflicts   = true
  server_side_apply = true

  depends_on = [helm_release.external_dns]
}

resource "kubectl_manifest" "grafana_secret_provider" {
  yaml_body = templatefile("${path.module}/k8s/monitoring-secretproviderclass.yml", {
    MANAGED_IDENTITY_CLIENT_ID = module.uami_grafana.client_id
    KEY_VAULT_NAME             = module.kv.key_vault_name
    TENANT_ID                  = data.azurerm_client_config.current.tenant_id
  })

  force_conflicts   = true
  server_side_apply = true

  depends_on = [helm_release.kube_prometheus_stack]
}

resource "kubectl_manifest" "app_secret_provider" {
  yaml_body = templatefile("${path.module}/k8s/app-secretproviderclass.yml", {
    APPLICATION_CLIENT_ID = module.uami_attendance_crm.client_id
    KEY_VAULT_NAME        = module.kv.key_vault_name
    TENANT_ID             = data.azurerm_client_config.current.tenant_id
  })

  force_conflicts   = true
  server_side_apply = true

  depends_on = [module.aks, kubectl_manifest.app_service_account]
}

resource "kubectl_manifest" "app_service_account" {
  yaml_body = templatefile("${path.module}/k8s/app-serviceaccount.yml", {
    APPLICATION_CLIENT_ID = module.uami_attendance_crm.client_id
  })

  force_conflicts   = true
  server_side_apply = true

  depends_on = [module.aks]
}

resource "kubernetes_secret" "attendance_crm" {
  metadata {
    name      = "attendance-crm-secrets"
    namespace = "attendance-crm"
  }
  data = {
     "ConnectionStrings__AttendanceCRM"     = "data source=${module.sql.sql_server_fqdn};initial catalog=${module.sql.sql_database_name};user id=${module.sql.sql_server_admin_login};password=${random_password.sql_server_admin_password.result};TrustServerCertificate=True;"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.appi.connection_string
  }
}