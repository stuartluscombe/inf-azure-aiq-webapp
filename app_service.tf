resource "azurerm_service_plan" "main" {
  name                = "sp-${local.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "main" {
  name                = "as-${local.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only = true

  site_config {
    application_stack {
      python_version = "3.13"
    }
  }

  tags = local.tags
}

