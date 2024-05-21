resource "random_password" "admin_password" {
  length           = 16 # 128
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.vaultcore.azure.net"
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
      elastic_pool_id = module.sql_server.resource_elasticpools["sample_pool"].id
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
  # source = "../../"
  source = "./../../../../../../modules/databases/terraform-azurerm-avm-res-sql-server"  
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  enable_telemetry             = var.enable_telemetry
  name                         = "${module.naming.mssql_server.name}${random_string.this.result}" # module.naming.sql_server.name_unique
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  administrator_login          = "sqladminuser"
  administrator_login_password = random_password.admin_password.result

  databases     = local.databases
  elastic_pools = local.elastic_pools

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.private_dnz_zone_output.id] # [azurerm_private_dns_zone.this.id]
      subnet_resource_id            = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["DbSubnet"].id  # azurerm_subnet.this.id
    }
  }

  tags = { 
    purpose = "mssql database" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "db"           
  }  
  depends_on = [
    module.azurerm_resource_group.this
  ]
}







# resource "azurerm_user_assigned_identity" "this" {
#   name                = "msi-sqlserver"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
# }

# module "mssql_server" {
#   source = "./../../../../../../modules/databases/terraform-azurerm-sql-server"
#   depends_on = [
#     azurerm_user_assigned_identity.this, 
#     module.keyvault,
#   ]  

#   name                          = "${module.naming.mssql_server.name}${random_string.this.result}" # module.naming.mssql_server.name_unique 
#   resource_group_name           = azurerm_resource_group.this.name 
#   location                      = azurerm_resource_group.this.location 
#   mssql_version                 = "12.0" 
#   administrator_login           = "sqladminuser" 
#   administrator_login_password  = module.keyvault.resource_secrets["sql_admin_password"].value 
#   public_network_access_enabled = true 
#   connection_policy             = "Default" 
#   minimum_tls_version           = "1.2" 
#   tags = { 
#     purpose = "mssql server" 
#     project_code = local.global_settings.prefix 
#     env = local.global_settings.environment 
#     zone = "project"
#     tier = "db"           
#   }   

#   azuread_administrator = {
#     azuread_authentication_only = false
#     login_username = azurerm_user_assigned_identity.this.name
#     object_id      = azurerm_user_assigned_identity.this.principal_id
#   }

#   identity = {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.this.id]
#   }

#   primary_user_assigned_identity_id            = azurerm_user_assigned_identity.this.id

# }

# module mssql_elastic_pool {
#   source = "./../../../../../../modules/databases/terraform-azurerm-sql-elasticpool"
#   depends_on = [module.mssql_server]  

#   name                = "${module.naming.mssql_elasticpool.name}${random_string.this.result}" # module.naming.mssql_elasticpool.name_unique 
#   resource_group_name = azurerm_resource_group.this.name 
#   location            = azurerm_resource_group.this.location 
#   server_name         = module.mssql_server.resource.name 
#   max_size_gb         = "756" 
#   max_size_bytes      = null 
#   zone_redundant      = false 
#   license_type        = "LicenseIncluded" 
#   tags                = {
#     env = local.global_settings.environment 
#   } 

#   sku = {
#     name     = "GP_Gen5"
#     tier     = "GeneralPurpose" # Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale
#     family   = "Gen5"
#     capacity = 4
#   }

#   per_database_settings = {
#     min_capacity = 0.25
#     max_capacity = 4
#   }
# }

# module mssql_database {
#   source = "./../../../../../../modules/databases/terraform-azurerm-sql-database"
#   depends_on = [module.mssql_server]  

#   name               = "${module.naming.mssql_database.name}${random_string.this.result}" # module.naming.mssql_database.name_unique 
#   resource_group_name = azurerm_resource_group.this.name 
#   server_id   = module.mssql_server.resource.id 
#   # to avoid update due to "geo_backup_enabled = true -> false"
#   # geo_backup_enabled is only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs.
#   geo_backup_enabled = true # since it is ignore caf terraform is default is false
#   license_type   = "LicenseIncluded"
#   max_size_gb    = 1
#   sku_name       = "S0"
#   zone_redundant = false # true

#   tags = { 
#     purpose = "mssql database" 
#     project_code = local.global_settings.prefix 
#     env = local.global_settings.environment 
#     zone = "project"
#     tier = "db"           
#   }   
# }

