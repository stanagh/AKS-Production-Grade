variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region where the AKS cluster will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the AKS cluster."
  type        = map(string)
  default     = {}
}

variable "role_based_access_control_enabled" {
  description = "Whether to enable role-based access control (RBAC) for the AKS cluster."
  type        = bool
  default     = true
}

variable "dns_prefix" {
  description = "The DNS prefix to use with the AKS cluster."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 2
}

variable "node_sku" {
  description = "The SKU of the nodes in the default node pool."
  type        = string
  default     = "Standard_B2s"
}

variable "subnet_id" {
  description = "The ID of the subnet to which the AKS cluster will be connected."
  type        = string
}

variable "identity_type" {
  description = "The type of identity to use for the AKS cluster. Possible values are 'SystemAssigned' and 'UserAssigned'."
  type        = string
  default     = "SystemAssigned"
}

variable "aks_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for the AKS cluster."
  type        = string
  default     = "aks-diagnostic-setting"
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to which AKS diagnostics will be sent."
  type        = string
}