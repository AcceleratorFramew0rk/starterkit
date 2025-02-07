module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.redis.cache.windows.net"

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "redis cache private dns zone" 
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
            purpose = "redis cache vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "db"   
          }
        )

      }
    }
}

module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"
  
  name                           = "${module.redis_cache.resource.name}PrivateEndpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["DbSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["DbSubnet"].resource.id : var.subnet_id 
  tags                           = {
      env = try(local.global_settings.environment, var.environment)  
    }
  private_connection_resource_id = module.redis_cache.resource.id
  is_manual_connection           = false
  subresource_name               = "redisCache"
  private_dns_zone_group_name    = "default"
  private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
  depends_on = [
    module.private_dns_zones,
    module.redis_cache
  ]
}

module "redis_cache" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/databases/terraform-azurerm-redis-cache"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/databases/terraform-azurerm-redis-cache"
  
  name                         = "${module.naming.redis_cache.name}-${random_string.this.result}" 
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
 
  # add the variables here
  capacity                      = 1  
  family                        = "P"
  sku_name                      = "Premium"
  shard_count                   = 1
  public_network_access_enabled = false  
  redis_configuration = {
    rdb_backup_enabled = false
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "redis cache" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 

}


