variable "dns_zone_name" {
  description = "The name of the DNS zone to create."
  type        = string
  default     = "attendanceappservice.online"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the DNS zone."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the DNS zone."
  type        = map(string)
}