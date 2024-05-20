module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "sandpitlabs.com"
  dns_zone_tags         = {
      env = local.global_settings.environment 
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_network.id 
        autoregistration = true
        tags = {
          env = local.global_settings.environment 
        }
      }
    }
}

