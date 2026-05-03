variable "hosted_zone_name" {
  type    = string
  default = "attendanceappservice.online"
}

variable "email_address" {
  type    = string
  default = "staghara@icloud.com"
}

variable "personal_ip_address" {
  description = "Your personal IP address to allow access to the SQL Server. If not provided, it will default to your current public IP address."
  type        = string
  default     = ""
}