module "public_ip_firewall1" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"
  
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.public_ip.name_unique}-fw1"
  location            = azurerm_resource_group.this.location 
}

module "public_ip_firewall2" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.public_ip.name}-fw2"
  location            = azurerm_resource_group.this.location 
}

module "firewall" {
  source  = "Azure/avm-res-network-azurefirewall/azurerm"
  version = "0.1.2"
  
  name                = "${module.naming.firewall.name}-egress-internet"
  enable_telemetry    = var.enable_telemetry
  location            = azurerm_resource_group.this.location
  resource_group_name = local.remote.resource_group.name # firewall must be in the same resource group as virtual network and subnets
  firewall_sku_tier   = "Basic" # "Premium" or "Standard"
  firewall_policy_id  = module.firewall_policy.id.id # bug in avm module which output resource to id or name variable
  firewall_sku_name   = "AZFW_VNet"
  firewall_zones      = ["1", "2", "3"]
  firewall_ip_configuration = [
    {
      name                 = "ipconfig1"
      subnet_id            = local.remote.networking.virtual_networks.hub_internet_egress.virtual_subnets.subnets["AzureFirewallSubnet"].id # module.virtualnetwork_ingress_egress.subnets["AzureFirewallSubnet"].id  # azurerm_subnet.subnet.id
      public_ip_address_id = module.public_ip_firewall1.public_ip_id # azurerm_public_ip.public_ip.id
    }
  ]

  # firewall_management_ip_configuration is an object and not a list, therefore no []
  firewall_management_ip_configuration = {
    name                 = "ipconfig2"
    subnet_id            = local.remote.networking.virtual_networks.hub_internet_egress.virtual_subnets.subnets["AzureFirewallManagementSubnet"].id # module.virtualnetwork_ingress_egress.subnets["AzureFirewallManagementSubnet"].id  # azurerm_subnet.subnet.id
    public_ip_address_id = module.public_ip_firewall2.public_ip_id # azurerm_public_ip.public_ip.id
  }

  tags = { 
    purpose = "hub internet egress firewall" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "hub internet"
    tier = "na"          
  } 

  depends_on = [
    module.public_ip_firewall1,
    module.public_ip_firewall2,
    module.firewall_policy        
  ]
}
