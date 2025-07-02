resource "azurerm_network_security_group" "example" {
  name                = "nsg-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "mssql" {
  name = "subnet-mssql-${local.project_name}-${local.environment}"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "mssql-delegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "mssql" {
  subnet_id                 = azurerm_subnet.mssql.id
  network_security_group_id = azurerm_network_security_group.mssql.id
}

resource "azurerm_subnet" "app_service" {
  name = "subnet-app-service-${local.project_name}-${local.environment}"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "app_service" {
  subnet_id                 = azurerm_subnet.app_service.id
  network_security_group_id = azurerm_network_security_group.app_service.id
}

resource "azurerm_route_table" "main" {
  name                = "route-table-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  bgp_route_propagation_enabled = true

  tags = local.tags

  depends_on = [
    azurerm_subnet.mssql
  ]
}

resource "azurerm_subnet_route_table_association" "mssql" {
  subnet_id      = azurerm_subnet.mssql.id
  route_table_id = azurerm_route_table.main.id
}