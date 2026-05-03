variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

variable "location" {
  description = "The Azure region where the virtual network will be created."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string

}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}


variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "snet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

variable "service_endpoints" {
  description = "The service endpoints to enable on the subnet."
  type        = list(string)
  default     = ["Microsoft.Sql", "Microsoft.KeyVault"]
}
