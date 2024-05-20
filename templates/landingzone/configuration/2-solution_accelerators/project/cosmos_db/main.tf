module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.documents.azure.com"
  dns_zone_tags         = {
      environment = "dev"
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
        autoregistration = false # true
        tags = {
          "env" = "dev"
        }
      }
    }
}

module "cosmos_db" {
  source              = "./../../../../../../modules/databases/terraform-azurerm-cosmosdb"
  
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = "${module.naming.cosmosdb_account.name}${random_string.this.result}" 
  cosmos_api          = var.cosmos_api
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers
  private_endpoint = {
    "pe_endpoint" = {
      dns_zone_group_name             = var.dns_zone_group_name
      dns_zone_rg_name                = azurerm_resource_group.this.name 
      enable_private_dns_entry        = true
      is_manual_connection            = false
      name                            = var.pe_name
      private_service_connection_name = var.pe_connection_name
      subnet_name                     = "DbSubnet" 
      vnet_name                       = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
      vnet_rg_name                    = local.remote.resource_group.name  
    }
  }

  tags = { 
    purpose = "azure open ai service" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "ai"           
  } 
  
  depends_on = [
    azurerm_resource_group.this,
    module.private_dns_zones
  ]
}
