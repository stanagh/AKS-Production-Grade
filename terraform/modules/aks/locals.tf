locals {
  aks_log_categories = [
    "kube-apiserver",
    "kube-controller-manager",
    "kube-scheduler",
    "kube-audit",
    "kube-audit-admin",
    "guard",
    "cluster-autoscaler",
  ]
}