resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
  depends_on = [module.aks]
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  depends_on = [module.aks]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [module.aks]
}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
  depends_on = [module.aks]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [module.aks]
}

resource "kubernetes_namespace" "attendance_crm" {
  metadata {
    name = "attendance-crm"
  }
  depends_on = [module.aks]
}

resource "kubernetes_namespace" "external_dns_azure_config" {
  metadata {
    name = "external-dns-azure-config"
  }
  depends_on = [module.aks]
}

