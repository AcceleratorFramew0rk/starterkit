resource "azurerm_app_service_plan" "this" {
  name                         = "${module.naming.app_service_plan.name}-appservice" # module.naming.app_service_plan.name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  # kind                         = "Linux"
  kind                         = "Windows"
  maximum_elastic_worker_count = 5 

  # For kind=Linux must be set to true and for kind=Windows must be set to false
  reserved         = false 

  sku {
    tier     = "Standard"
    size     = "S1"
  }
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

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

  site_config = { 
    dotnet_framework_version = "v6.0" # site_config.0.dotnet_framework_version to be one of ["v2.0" "v4.0" "v5.0" "v6.0"], got v4.8
  }


  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
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

  # Enabling Application Insights
  application_insights = {
    name                = "${module.naming.app_service.name}-ai"
    resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
    location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
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
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.subnet_id 
  tags                           = {
      environment = "dev"
    }
  private_connection_resource_id = module.appservice.resource.id
  is_manual_connection           = false
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default" 
  private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
}

# Tested with :  AzureRM version 2.55.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config" {
  app_service_id = module.appservice.resource.id
  subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppServiceSubnet"].resource.id : var.subnet_id 
}


