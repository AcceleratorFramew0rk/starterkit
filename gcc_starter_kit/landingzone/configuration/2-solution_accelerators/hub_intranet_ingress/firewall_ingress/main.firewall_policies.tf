module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"

  enable_telemetry    = var.enable_telemetry
  name                = "${module.naming.firewall_policy.name}-iz-${random_string.this.result}" # module.naming.firewall_policy.name_unique
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  firewall_policy_sku = "Premium" # "Basic" # both firewall and firewall policy must in same tier
}

module "rule_collection_group" {
  source             = "Azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"

  firewall_policy_rule_collection_group_firewall_policy_id = module.firewall_policy.resource.id
  firewall_policy_rule_collection_group_name               = "NetworkRuleCollectionGroup"
  firewall_policy_rule_collection_group_priority           = 400
  firewall_policy_rule_collection_group_network_rule_collection = [
    {
      action   = "Allow"
      name     = "NetworkRuleCollection"
      priority = 400
      rule = [
        {
          name                  = "OutboundToInternet"
          description           = "Allow traffic outbound to the Internet"
          destination_addresses = ["0.0.0.0/0"]
          destination_ports     = ["443"]
          source_addresses      = ["*"] # define the cidr ip
          protocols             = ["TCP"]
        }
      ]
    }
  ]
  firewall_policy_rule_collection_group_application_rule_collection = [
    {
      action   = "Allow"
      name     = "ApplicationRuleCollection"
      priority = 600
      rule = [
        {
          name             = "AllowAll"
          description      = "Allow traffic to Microsoft.com"
          source_addresses = ["*"]  # define the cidr ip
          protocols = [
            {
              port = 443
              type = "Https"
            }
          ]
          destination_fqdns = ["microsoft.com"]
        }
      ]
    }
  ]
}
