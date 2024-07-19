module "network_security_groups" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  for_each = try(var.subnets.hub_internet_ingress, null) == null ? local.global_settings.subnets.hub_internet_ingress : var.subnets.hub_internet_ingress

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = lower("${module.naming.network_security_group.name}-${each.value.name}") # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules      = try(each.value.name, null) == "AgwSubnet" ? local.config["InternetAgwSubnet"] : try(local.config[each.value.name], null)

}


