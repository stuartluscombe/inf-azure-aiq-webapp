resource "azurerm_user_assigned_identity" "main" {
  name                = "uai-${local.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_federated_identity_credential" "main" {
  name                = "federated-identity-${local.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  parent_id           = azurerm_user_assigned_identity.main.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${local.github_organization}/${local.repository_name}:environment:${local.environment}"
}

resource "azurerm_role_assignment" "main" {
  scope                = azurerm_linux_web_app.main.id
  role_definition_name = "Website Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id

  depends_on = [
    azurerm_federated_identity_credential.main
  ]
}