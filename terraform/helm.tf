resource "helm_release" "ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.8"
  namespace        = kubernetes_namespace.ingress_nginx.metadata[0].name
  create_namespace = false
  values = [
    file("./helm-values/ingress-nginx.yml")
  ]
  depends_on = [module.aks]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.17.2"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = false
  values = [
    file("./helm-values/cert-manager.yml")
  ]
  depends_on = [module.aks]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = "1.15.2"
  namespace        = kubernetes_namespace.external_dns.metadata[0].name
  create_namespace = false
  timeout          = 600
  wait             = false

  values = [
    templatefile("${path.module}/helm-values/external-dns.yml", {
      EXTERNAL_DNS_CLIENT_ID = module.uami_external_dns.client_id
      RESOURCE_GROUP_NAME    = data.azurerm_resource_group.rg.name
      AZURE_SUBSCRIPTION_ID  = data.azurerm_client_config.current.subscription_id
      AZURE_TENANT_ID        = data.azurerm_client_config.current.tenant_id
    })
  ]

  set {
    name  = "extraVolumes[0].name"
    value = "azure-config"
  }
  set {
    name  = "extraVolumes[0].secret.secretName"
    value = "external-dns-azure-config"
  }
  set {
    name  = "extraVolumeMounts[0].name"
    value = "azure-config"
  }
  set {
    name  = "extraVolumeMounts[0].mountPath"
    value = "/etc/kubernetes"
  }
  set {
    name  = "extraVolumeMounts[0].readOnly"
    value = "true"
  }

  depends_on = [
    module.aks,
    kubernetes_secret.external_dns_azure_config # ← secret must exist first
  ]
}


resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "82.10.4"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  timeout          = 600
  wait             = false

  values = [
    file("./helm-values/kube-prometheus-stack.yml")
  ]

  set {
    name  = "grafana.serviceAccount.annotations.azure\\.workload\\.identity/client-id"
    value = module.uami_grafana.client_id
  }

  set {
    name  = "grafana.podLabels.azure\\.workload\\.identity/use"
    value = "true"
    type  = "string"
  }
  depends_on = [module.aks, helm_release.cert_manager]

}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.4.10"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  values = [
    file("./helm-values/argocd.yml")
  ]
  depends_on = [module.aks, helm_release.ingress]
}