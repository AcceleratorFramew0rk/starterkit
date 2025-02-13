module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.3.0"

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

# This is the module call
module "redis_cache" {
  source             = "Azure/avm-res-cache-redis/azurerm"
  version            = "0.2.0"

  enable_telemetry              = var.enable_telemetry
  name                          = "${module.naming.redis_cache.name}-${random_string.this.result}"  # module.naming.redis_cache.name_unique
  resource_group_name           = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  # add the variables here
  # capacity                      = 1  
  # family                        = "P"
  sku_name                      = "Premium"
  # shard_count                   = 1

  public_network_access_enabled = false
  private_endpoints = {
    endpoint1 = {
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id  # azurerm_subnet.endpoint.id
      private_dns_zone_group_name   = "private-dns-zone-group"
      private_dns_zone_resource_ids = [module.private_dns_zones.resource.id]  # [azurerm_private_dns_zone.this.id]
    }
  }

  diagnostic_settings = {
    diag_setting_1 = {
      name                           = "${module.naming.monitor_diagnostic_setting.name_unique}-redis-cache" # "diagSetting1"
      log_groups                     = ["allLogs"]
      metric_categories              = ["AllMetrics"]
      log_analytics_destination_type = null
      workspace_resource_id          = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id # azurerm_log_analytics_workspace.this_workspace.id
    }
  }

  redis_configuration = {
    maxmemory_reserved = 1330
    maxmemory_delta    = 1330
    maxmemory_policy   = "allkeys-lru"
    rdb_backup_enabled = false
  }
  /*
  lock = {
    kind = "CanNotDelete"
    name = "Delete"
  }
  */

  managed_identities = {
    system_assigned = true
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
