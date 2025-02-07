module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name
  domain_name           = local.global_settings.app_config.private_dns_zones.internet_ingress_domain_name # "sandpitlabs.com" # remove this hardcode, set it in config.yaml
  tags         = {
      env = local.global_settings.environment 
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = local.remote.networking.virtual_networks.hub_internet_ingress.virtual_network.id 
        autoregistration = true
        tags = {
          env = local.global_settings.environment 
        }
      }
    }
}

