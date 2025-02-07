module "network_security_groups" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  for_each = try(var.subnets.project, null) == null ? local.global_settings.subnets.project : var.subnets.project

  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name
  name                = lower("${module.naming.network_security_group.name}-${each.value.name}") # between 3 and 24 characters
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  security_rules      = try(local.config[each.value.name], null)  

}


