variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure Container Registry."
  type        = string
}

variable "location" {
  description = "The Azure region where the Azure Container Registry will be created."
  type        = string
}

variable "sku" {
  description = "The SKU of the Azure Container Registry. Possible values are 'Basic', 'Standard', and 'Premium'."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled for the Azure Container Registry."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the Azure Container Registry."
  type        = map(string)
  default     = {}
}
