variable "location" {
  description = "The Azure region where the managed identity will be created."
  type        = string
}

variable "name" {
  description = "The name of the managed identity."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the managed identity."
  type        = string
}

variable "federated_identity_credential" {
  description = "Whether to create a federated identity credential for the managed identity."
  type        = bool
  default     = true
}

variable "oidc_issuer_url" {
  description = "The OIDC issuer URL for the federated identity credential. Required if 'federated_identity_credential' is true."
  type        = string
}

variable "service_account_namespace" {
  description = "The namespace of the Kubernetes service account for the federated identity credential. Required if 'federated_identity_credential' is true."
  type        = string
}

variable "service_account_name" {
  description = "The name of the Kubernetes service account for the federated identity credential. Required if 'federated_identity_credential' is true."
  type        = string
}
