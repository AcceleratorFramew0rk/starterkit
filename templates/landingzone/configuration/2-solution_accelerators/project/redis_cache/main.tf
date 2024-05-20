module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.redis.cache.windows.net"
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
  
  name                           = "${module.redis_cache.resource.name}PrivateEndpoint"
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  subnet_id                      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["DbSubnet"].id 
  tags                           = {
      env = local.global_settings.environment 
    }
  private_connection_resource_id = module.redis_cache.resource.id
  is_manual_connection           = false
  subresource_name               = "redisCache"
  private_dns_zone_group_name    = "default"
  private_dns_zone_group_ids     = [module.private_dns_zones.private_dnz_zone_output.id] 
  depends_on = [
    module.private_dns_zones,
    module.redis_cache
  ]
}

module "redis_cache" {
  source = "./../../../../../../modules/databases/terraform-azurerm-redis-cache"

  name                         = "${module.naming.redis_cache.name}${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  tags = { 
    purpose = "redis cache" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "db"           
  } 
  # add the variables here
  capacity                      = 1  
  family                        = "P"
  sku_name                      = "Premium"
  shard_count                   = 1
  public_network_access_enabled = false  
  redis_configuration = {
    rdb_backup_enabled = false
  }

}


