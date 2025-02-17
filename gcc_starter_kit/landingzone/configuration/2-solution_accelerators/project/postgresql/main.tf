module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2"

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.postgres.database.azure.com"
  tags         = merge(
    local.global_settings.tags,
    {
      purpose = "postgresql server dns zone" 
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
        tags = merge(
          local.global_settings.tags,
          {
            purpose = "postgresql server vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "service"   
          }
        )
      }
      vnetlink2 = {
        vnetlinkname     = "vnetlink2"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_devops.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_devops.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = merge(
          local.global_settings.tags,
          {
            purpose = "postgresql server vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "service"   
          }
        )
      }      
    }
}


module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

  name                           = "${module.postgresql.name}PrivateEndpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "postgresql server private endpoint" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 
  private_connection_resource_id = module.postgresql.resource_id
  is_manual_connection           = false
  subresource_name               = "postgresqlServer"
  private_dns_zone_group_name    = "PostgresqlPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "postgresql" {
  # source = "../../"
  source  = "Azure/avm-res-dbforpostgresql-flexibleserver/azurerm"
  version = "0.1.2" 

  location               = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                   = "${module.naming.postgresql_server.name_unique}${random_string.this.result}" # module.naming.postgresql_server.name_unique
  resource_group_name    = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  enable_telemetry       = var.enable_telemetry
  administrator_login    = "psqladmin"
  administrator_password = "!qaz@wsx@1234567890!qaz@wsx@1234567890" # random_password.myadminpassword.result
  server_version         = 16
  sku_name               = "GP_Standard_D2s_v3"
  zone                   = 1
  high_availability = {
    mode                      = "ZoneRedundant"
    standby_availability_zone = 2
  }
  # tags = null
  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "postgresql server" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 
}
