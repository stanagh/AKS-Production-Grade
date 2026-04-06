variable "appi_name" {
  description = "The name of the Application Insights resource."
  type        = string
}

variable "location" {
  description = "The location of the Application Insights resource."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "application_type" {
  description = "The type of the Application Insights resource."
  type        = string
  default     = "web"
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "frequency" {
  description = "The frequency of the availability test in seconds."
  type        = number
  default     = 300
}

variable "timeout" {
  description = "The timeout of the availability test in seconds."
  type        = number
  default     = 30
}

variable "enabled" {
  description = "Whether the availability test is enabled."
  type        = bool
  default     = true
}

variable "geo_locations" {
  description = "The geo locations for the availability test."
  type        = list(string)
  default     = ["emea-se-sto-edge", "emea-ru-msa-edge", "emea-nl-ams-azr", "emea-fr-pra-edge"]
}

variable "availability_url" {
  description = "The URL to test for availability."
  type        = string
}

variable "expected_http_status_code" {
  description = "The expected HTTP status code for the availability test."
  type        = number
  default     = 200
}
