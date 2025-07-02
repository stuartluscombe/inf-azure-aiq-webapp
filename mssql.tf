resource "azurerm_mssql_server" "main" {
  name                         = "mssql-server-${local.project_name}-${local.environment}"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  version                      = "12.0"
  administrator_login          = var.mssql_admin_login
  administrator_login_password = var.mssql_admin_password

  tags = local.tags
}

resource "azurerm_mssql_database" "main" {
  name         = "mssql-database-${local.project_name}-${local.environment}"
  server_id    = azurerm_mssql_server.main.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "BasePrice"
  sku_name     = "S0"
  max_size_gb  = 32

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}