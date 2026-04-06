variable "name" {
  description = "The name suffix for alert resources."
  type        = string
}

variable "alert_rule_name" {
  description = "The name of the alert rule."
  type        = string
  default     = "High CPU Usage"
}

variable "alert_email" {
  description = "The email address to send alert notifications to."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the alert rule."
  type        = string
}

variable "severity" {
  description = "The severity of the alert rule. Possible values are 'Sev0', 'Sev1', 'Sev2', 'Sev3', and 'Sev4'."
  type        = string
  default     = "Sev3"
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace."
  type        = string
}

variable "app_insights_id" {
  description = "The ID of the Application Insights resource."
  type        = string
}

variable "enabled" {
  description = "Whether the alert rule is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

