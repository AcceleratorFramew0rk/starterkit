module "public_ip_firewall1" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"
  
  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  name                = "${module.naming.public_ip.name_unique}-1-fwingressez"
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
}

module "firewall" {
  source  = "Azure/avm-res-network-azurefirewall/azurerm"
  version = "0.1.4"
  
  name                = "${module.naming.firewall.name}-ingress-internet"
  enable_telemetry    = var.enable_telemetry
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name = try(local.remote.resource_group.name, null) != null ? local.remote.resource_group.name : var.platform_resource_group_name # firewall must be in the same resource group as virtual network and subnets
  firewall_sku_tier   = "Premium" # "Basic"  # "Standard"
  firewall_policy_id  = module.firewall_policy.resource.id # bug in avm module which output resource to id or name variable
  firewall_sku_name   = "AZFW_VNet"
  firewall_zones      = ["1", "2", "3"]
  firewall_ip_configuration = [
    {
      name                 = "${module.naming.firewall.name}-fwingressez-ipconfig" 
      # subnet_id            = local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets["AzureFirewallSubnet"].resource.id # module.virtualnetwork_ingress_ingress.subnets["AzureFirewallSubnet"].resource.id  # azurerm_subnet.subnet.id
      subnet_id            = try(local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets["AzureFirewallSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets["AzureFirewallSubnet"].resource.id : var.subnet_id 
      public_ip_address_id = module.public_ip_firewall1.public_ip_id # azurerm_public_ip.public_ip.id
    }
  ]

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "hub internet ingress firewall" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "hub internet"
      tier = "na"   
    }
  )

  depends_on = [
    module.public_ip_firewall1,
    module.firewall_policy        
  ]
}
