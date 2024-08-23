resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "asp-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "B1"
  }

  tags = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.project}${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = var.tags
}

resource "azurerm_app_service" "webapp1" {
  name                = "ui-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.project}/ui:latest"
    always_on        = true
    vnet_route_all_enabled = true
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITE_VNET_ROUTE_ALL"          = "1"
  }

  depends_on = [
    azurerm_app_service_plan.app_service_plan,
    azurerm_container_registry.acr,
    azurerm_subnet.subnetweb
  ]

  tags = var.tags

}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp1_vnet_integration" {
  app_service_id    = azurerm_app_service.webapp1.id
  subnet_id         = azurerm_subnet.subnetweb.id
  depends_on = [
    azurerm_app_service.webapp1
  ]
}

resource "azurerm_app_service" "webapp2" {
  name                = "api-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.project}/api:latest"
    always_on        = true
    vnet_route_all_enabled = true
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITE_VNET_ROUTE_ALL"          = "1"
  }

  depends_on = [
    azurerm_app_service_plan.app_service_plan,
    azurerm_container_registry.acr,
    azurerm_subnet.subnetweb
  ]

  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp2_vnet_integration" {
  app_service_id    = azurerm_app_service.webapp2.id
  subnet_id         = azurerm_subnet.subnetweb.id

  depends_on = [
    azurerm_app_service.webapp2
  ]

}