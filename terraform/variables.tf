variable "sql_server_admin_password" {
  description = "The administrator login password for the SQL Server."
  type        = string
  sensitive   = true
}

variable "hosted_zone_name" {
  type    = string
  default = "attendanceappservice.online"
}

variable "email_address" {
  type    = string
  default = "staghara@icloud.com"
}