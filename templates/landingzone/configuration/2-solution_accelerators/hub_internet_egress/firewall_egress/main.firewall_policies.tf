module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"

  enable_telemetry    = var.enable_telemetry
  name                = module.naming.firewall_policy.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  firewall_policy_sku = "Basic" # both firewall and firewall policy must in same tier
}
