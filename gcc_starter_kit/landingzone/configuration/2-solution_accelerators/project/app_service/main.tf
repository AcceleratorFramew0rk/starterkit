resource "azurerm_app_service_plan" "this" {
  name                         = "${module.naming.app_service_plan.name}-${random_string.this.result}" # module.naming.app_service_plan.name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  kind                         = "Linux"
  maximum_elastic_worker_count = 5 

  # For kind=Linux must be set to true and for kind=Windows must be set to false
  reserved         = true 

  sku {
    tier     = "Standard"
    size     = "S1"
  }
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  count = var.private_dns_zones_enabled ? 1 : 0

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.azurewebsites.net"
  tags         = {
      environment = "dev"
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = {
          "env" = "dev"
        }
      }
    }
}

module "appservice" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/webapps/terraform-azurerm-appservice"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/webapps/terraform-azurerm-appservice"

  name                         = "${module.naming.app_service.name}-web-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  app_service_plan_id = azurerm_app_service_plan.this.id
  client_affinity_enabled = false
  client_cert_enabled = false
  enabled = true
  https_only = false

  identity = {
    type = "SystemAssigned"
  }
  # key_vault_reference_identity_id = {} 
  site_config = {
    # Free tier only supports 32-bit
    use_32_bit_worker_process = true
    # Run "az webapp list-runtimes --linux" for current supported values, but
    # always connect to the runtime with "az webapp ssh" or output the value
    # of process.version from a running app because you might not get the
    # version you expect
    linux_fx_version = "NODE:20-lts" # "NODE|12-lts"
  }

  backup = {
    name                = "webapp_backup"
    enabled             = true
    # storage_account_key = "sa_backup"
    // container_key       = "backup"
    # storage_account = module.storageaccount.resource # to derive storage_account_url from the storage account module
    # storage_account_url = module.storageaccount.resource.primary_blob_endpoint # "https://cindstsabackup.blob.core.windows.net/webapp-backup?sv=2018-11-09&sr=c&st=2021-02-08T07%3A07%3A42Z&se=2021-03-10T07%3A07%3A42Z&sp=racwdl&spr=https&sig=5LX%2ByDoE4YQsf%2F0L5f42eML9mk%2Fu5ejjZYVIs81Keng%3D"

    sas_policy = {
      expire_in_days = 30
      rotation = {
        #
        # Set how often the sas token must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new sas token
        # Only set one of the value
        #

        # mins = 1 # only recommended for CI and demo
        days = 7
        # months = 1
      }
    }

    schedule = {
      frequency_interval       = 1
      frequency_unit           = "Day"
      keep_at_least_one_backup = true
      retention_period_in_days = 1
      start_time               = "2023-11-08T00:00:00Z"
    }
  }

  # logs = {
  #   application_logs = {
  #     file_system_level = "Error" # can be Warning, Information, Verbose or Off
  #     azure_blob_storage = {
  #       level             = "Error" # can be Warning, Information, Verbose or Off
  #       retention_in_days = 60
  #     }
  #   }

  #   detailed_error_messages_enabled = true
  #   failed_request_tracing_enabled  = true

  #   # lz_key = ""  # if in remote landingzone
  #   # storage_account_key = "logs"
  #   # container_key       = "logs"

  #   sas_policy = {
  #     expire_in_days = 30
  #     rotation = {
  #       #
  #       # Set how often the sas token must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new sas token
  #       # Only set one of the value
  #       #

  #       # mins = 1 # only recommended for CI and demo
  #       days = 7
  #       # months = 1
  #     }
  #   }

  # #   http_logs = {
  # #     azure_blob_storage = {
  # #       retention_in_days = 30
  # #     }

  # #     #
  # #     # Either azure_blob_storage or file_system can be used but not both at the same time
  # #     #

  # #     # file_system = {
  # #     #   retention_in_days = 30
  # #     #   retention_in_mb   = 2
  # #     # }

  # #     # storage_account_key = "logs"
  # #     # container_key       = "http_logs"
  # #     sas_policy = {
  # #       expire_in_days = 30
  # #       rotation = {
  # #         #
  # #         # Set how often the sas token must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new sas token
  # #         # Only set one of the value
  # #         #

  # #         # mins = 1 # only recommended for CI and demo
  # #         days = 7
  # #         # months = 1
  # #       }
  # #     }
  # #   }


  # }      

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    "Example" = "Extend",
    "LZ"      = "CAF"
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "app service" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

}


module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"
 
  name                           = "${module.appservice.resource.name}-web-privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id : var.subnet_id 
  tags                           = {
      environment = "dev"
    }
  private_connection_resource_id = module.appservice.resource.id
  is_manual_connection           = false
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default" 
  private_dns_zone_group_ids     = [module.private_dns_zones[0].resource.id] 
}

# Tested with :  AzureRM version 2.55.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config" {
  app_service_id = module.appservice.resource.id
  subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppServiceSubnet"].resource.id : var.subnet_id 
}


module "appservice1" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/webapps/terraform-azurerm-appservice"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/webapps/terraform-azurerm-appservice"

  name                         = "${module.naming.app_service.name}-api-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  app_service_plan_id = azurerm_app_service_plan.this.id
  client_affinity_enabled = false
  client_cert_enabled = false
  enabled = true
  https_only = false

  identity = {
    type = "SystemAssigned"
  }
  # key_vault_reference_identity_id = {} 
  site_config = {
    # Free tier only supports 32-bit
    use_32_bit_worker_process = true
    # Run "az webapp list-runtimes --linux" for current supported values, but
    # always connect to the runtime with "az webapp ssh" or output the value
    # of process.version from a running app because you might not get the
    # version you expect
    linux_fx_version = "NODE:20-lts" # "NODE|12-lts"
  }
  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    "Example" = "Extend",
    "LZ"      = "CAF"
  }

  backup = {
    name                = "api_backup"
    enabled             = true
    # storage_account_key = "sa_backup"
    // container_key       = "backup"
    # storage_account = module.storageaccount.resource # to derive storage_account_url from the storage account module
    # storage_account_url = module.storageaccount.resource.primary_blob_endpoint # "https://cindstsabackup.blob.core.windows.net/webapp-backup?sv=2018-11-09&sr=c&st=2021-02-08T07%3A07%3A42Z&se=2021-03-10T07%3A07%3A42Z&sp=racwdl&spr=https&sig=5LX%2ByDoE4YQsf%2F0L5f42eML9mk%2Fu5ejjZYVIs81Keng%3D"

    sas_policy = {
      expire_in_days = 30
      rotation = {
        #
        # Set how often the sas token must be rotated. When passed the renewal time, running the terraform plan / apply will change to a new sas token
        # Only set one of the value
        #

        # mins = 1 # only recommended for CI and demo
        days = 7
        # months = 1
      }
    }

    schedule = {
      frequency_interval       = 1
      frequency_unit           = "Day"
      keep_at_least_one_backup = true
      retention_period_in_days = 1
      start_time               = "2023-11-08T00:00:00Z"
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "app service" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

}

module "private_endpoint1" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"
 
  name                           = "${module.appservice.resource.name}-api-privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id : var.subnet_id 
  tags                           = {
      environment = "dev"
    }
  private_connection_resource_id = module.appservice1.resource.id
  is_manual_connection           = false
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default" 
  private_dns_zone_group_ids     = [module.private_dns_zones[0].resource.id] 
}

# Tested with :  AzureRM version 2.55.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config1" {
  app_service_id = module.appservice1.resource.id
  subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppServiceSubnet"].resource.id : var.subnet_id 
}

