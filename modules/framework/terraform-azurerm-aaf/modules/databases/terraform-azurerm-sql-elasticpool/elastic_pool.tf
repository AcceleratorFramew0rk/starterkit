resource "azurerm_mssql_elasticpool" "elasticpool" {

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = var.server_name
  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    family   = try(var.sku.family, null)
    capacity = var.sku.capacity
  }
  per_database_settings {
    min_capacity = var.per_database_settings.min_capacity
    max_capacity = var.per_database_settings.max_capacity
  }
  maintenance_configuration_name         = try(var.maintenance_configuration_name, null)
  max_size_gb         = try(var.max_size_gb, null)
  max_size_bytes      = try(var.max_size_bytes, null)
  enclave_type      = try(var.enclave_type, null)
  tags                = var.tags
  zone_redundant      = try(var.zone_redundant, null) # tier needs to be Premium for DTU based or BusinessCritical for vCore based sku
  license_type        = try(var.license_type, null)
}