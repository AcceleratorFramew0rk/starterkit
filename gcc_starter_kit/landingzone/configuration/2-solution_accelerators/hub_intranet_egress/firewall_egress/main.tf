module "public_ip_firewall1" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"
  
  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  name                = "${module.naming.public_ip.name_unique}-1-fweiz"
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
}

module "public_ip_firewall2" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  name                = "${module.naming.public_ip.name_unique}-2-fweiz"
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
}

module "firewall" {
  source  = "Azure/avm-res-network-azurefirewall/azurerm"
  version = "0.1.4"
  
  name                = "${module.naming.firewall.name}-egress-intranet"
  enable_telemetry    = var.enable_telemetry
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name = try(local.remote.resource_group.name, null) != null ? local.remote.resource_group.name : var.resource_group_name # firewall must be in the same resource group as virtual network and subnets
  firewall_sku_tier   = "Basic" # "Premium" or "Standard"
  firewall_policy_id  = module.firewall_policy.resource.id # bug in avm module which output resource to id or name variable
  firewall_sku_name   = "AZFW_VNet"
  firewall_zones      = ["1", "2", "3"]
  firewall_ip_configuration = [
    {
      name                 = "${module.naming.firewall.name}-fwegressiz-ipconfig"
      subnet_id            = try(local.remote.networking.virtual_networks.hub_intranet_egress.virtual_subnets["AzureFirewallSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_intranet_egress.virtual_subnets["AzureFirewallSubnet"].resource.id : var.subnet_id 
      public_ip_address_id = module.public_ip_firewall1.public_ip_id 
    }
  ]

  # firewall_management_ip_configuration is an object and not a list, therefore no []
  firewall_management_ip_configuration = {
    name                 = "${module.naming.firewall.name}-fwegressiz-ipconfigmgmt"
    subnet_id            = try(local.remote.networking.virtual_networks.hub_intranet_egress.virtual_subnets["AzureFirewallManagementSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_intranet_egress.virtual_subnets["AzureFirewallManagementSubnet"].resource.id : var.azurefirewallmanagement_subnet_id 
    public_ip_address_id = module.public_ip_firewall2.public_ip_id 
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "hub intranet egress firewall" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "hub intranet"
      tier = "na"   
    }
  ) 

  depends_on = [
    module.public_ip_firewall1,
    module.public_ip_firewall2,
    module.firewall_policy        
  ]
}
