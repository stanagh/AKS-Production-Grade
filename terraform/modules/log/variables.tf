variable "logs_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  type        = string
}

variable "location" {
  description = "The Azure region where the Log Analytics Workspace will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Log Analytics Workspace."
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Log Analytics Workspace. Possible values are 'PerGB2018' and 'Standalone'."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The number of days that the Log Analytics Workspace will retain data."
  type        = number
  default     = 30
}


variable "tags" {
  description = "A map of tags to assign to the Log Analytics Workspace."
  type        = map(string)
  default     = {}
}
