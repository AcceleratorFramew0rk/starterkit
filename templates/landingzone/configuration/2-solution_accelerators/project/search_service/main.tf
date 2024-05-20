module "searchservice" {
  source  = "./../../../../../../modules/cognitive_services/terraform-azurerm-searchservice"

  name                         = "${module.naming.search_service.name}${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  sku                 = "standard"
  # A system assigned identity must be provided even though the AzureRM provider states it is optional.
  managed_identities = {
    system_assigned = true
  }

  tags = { 
    purpose = "search service" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "ai"           
  }     

  depends_on = [azurerm_resource_group.this]
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.search.windows.net"
  dns_zone_tags         = {
      env = local.global_settings.environment 
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
        autoregistration = false # true
        tags = {
          env = local.global_settings.environment 
        }
      }
    }
}

module "private_endpoint" {
  source = "./../../../../../../modules/networking/terraform-azurerm-privateendpoint"
  
  name                           = "${module.searchservice.resource.name}PrivateEndpoint"
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  subnet_id                      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["AiSubnet"].id 
  tags                           = {
      env = local.global_settings.environment 
    }
  private_connection_resource_id = module.searchservice.resource.id
  is_manual_connection           = false
  subresource_name               = "searchService"
  private_dns_zone_group_name    = "default"
  private_dns_zone_group_ids     = [module.private_dns_zones.private_dnz_zone_output.id] 

  depends_on = [
    module.private_dns_zones,
    module.searchservice
  ]

}

