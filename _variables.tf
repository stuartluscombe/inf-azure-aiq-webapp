variable "mssql_admin_login" {
  description = "The administrator login for the SQL Server"
  type        = string
}

variable "mssql_admin_password" {
  description = "The administrator password for the SQL Server"
  type        = string
  sensitive   = true
}