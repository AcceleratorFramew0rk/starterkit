module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"

  enable_telemetry    = var.enable_telemetry
  name                = module.naming.firewall_policy.name_unique
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  firewall_policy_sku = "Basic" # both firewall and firewall policy must in same tier
}
