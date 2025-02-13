module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.documents.azure.com"

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "consmos db private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 

  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true

        tags        = merge(
          local.global_settings.tags,
          {
            purpose = "consmos db vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "db"   
          }
        ) 

      }
    }
}

module "cosmos_db" {
  # source              = "./../../../../../../modules/terraform-azurerm-aaf/modules/databases/terraform-azurerm-cosmosdb"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/databases/terraform-azurerm-cosmosdb"
  
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  cosmos_account_name = "${module.naming.cosmosdb_account.name}-${random_string.this.result}" 
  cosmos_api          = var.cosmos_api
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers

  # ensure location is south east asia
  geo_locations ={
    geo_location1 = {
      geo_location          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
      failover_priority = 0
      zone_redundant = false
    }
  }

  private_endpoint = {
    "pe_endpoint" = {
      dns_zone_group_name             = var.dns_zone_group_name
      dns_zone_rg_name                = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name 
      enable_private_dns_entry        = true
      is_manual_connection            = false
      name                            = "${module.naming.cosmosdb_account.name}-${random_string.this.result}-privateendpoint" # var.pe_name
      private_service_connection_name = "${module.naming.cosmosdb_account.name}-${random_string.this.result}-serviceconnection" # var.pe_connection_name
      # subnet_id                       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["CosmosDbSubnet"].resource.id, null)
      subnet_id                       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
      location                        = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
      resource_group_name              = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name 
      subnet_name                     = null # "CosmosDbSubnet" 
      vnet_name                       = null # try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.name : var.vnet_name  
      vnet_rg_name                    = null # try(local.remote.resource_group.name, null) != null ? local.remote.resource_group.name : var.vnet_resource_group_name  
    }
  }

  # # tags is from local variable in the modules. to fix this - fixed on 13 Jun 2024.
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "consmos db" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 
  
  depends_on = [
    azurerm_resource_group.this,
    module.private_dns_zones
  ]
}
