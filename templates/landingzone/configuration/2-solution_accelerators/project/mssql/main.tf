module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.vaultcore.azure.net"

  dns_zone_tags        = merge(
    local.global_settings.tags,
    {
      purpose = "mssql database private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 

  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null)  != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id   
        autoregistration = false # true

        tags        = merge(
          local.global_settings.tags,
          {
            purpose = "mssql database vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "db"   
          }
        ) 

      }
    }
}

locals {
  elastic_pools = {
    elasticpool1 = {
      sku = {
        name     = "StandardPool"
        capacity = 50
        tier     = "Standard"
      }
      per_database_settings = {
        min_capacity = 50
        max_capacity = 50
      }
      maintenance_configuration_name = "SQL_Default"
      zone_redundant                 = false
      license_type                   = "LicenseIncluded"
      max_size_gb                    = 50
    }
  }

  databases = {
    database1 = {
      create_mode     = "Default"
      collation       = "SQL_Latin1_General_CP1_CI_AS"
      elastic_pool_id = module.sql_server.resource_elasticpools["elasticpool1"].id
      license_type    = "LicenseIncluded"
      max_size_gb     = 50
      sku_name        = "ElasticPool"

      short_term_retention_policy = {
        retention_days           = 1
        backup_interval_in_hours = 24
      }
    }
  }
}

# This is the module call
module "sql_server" {
  # source = "./../../../../../../modules/databases/terraform-azurerm-avm-res-sql-server"  
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/databases/terraform-azurerm-avm-res-sql-server"  
  
  enable_telemetry             = var.enable_telemetry
  name                         = "${module.naming.mssql_server.name}${random_string.this.result}" 
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  administrator_login          = "sqladminuser"
  administrator_login_password = random_password.sql_admin.result 

  databases     = local.databases
  elastic_pools = local.elastic_pools

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.private_dnz_zone_output.id] 
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["DbSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["DbSubnet"].id : var.subnet_id  
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "mssql database" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 

  depends_on = [
    module.keyvault
  ]
}

