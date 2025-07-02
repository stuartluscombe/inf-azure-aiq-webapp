resource "azurerm_network_security_group" "mssql" {
  name                = "nsg-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.tags
}

resource "azurerm_network_security_group" "app_service" {
  name                = "nsg-app-service-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.tags
}