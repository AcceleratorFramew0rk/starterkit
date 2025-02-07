resource "azurerm_app_service_plan" "this" {
  name                         = "${module.naming.app_service_plan.name}-logicapp"
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  kind                         = "elastic" # "Linux"
  maximum_elastic_worker_count = 5 

  # For kind=Linux must be set to true and for kind=Windows must be set to false
  reserved         = true 

  sku {
    tier     = "WorkflowStandard" # "Standard"
    size     = "WS1" # "S1"
  }
}

# this is not required if app service exists - use azurerm resource logic - do not use AVM
module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  # execute this module if private dns zone from app service module is not available
  count = try(local.privatednszone.id, null) == null ? 1 : 0 

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

module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"
 
  name                           = "${module.logicapp.resource.name}-privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.service_subnet_id 
  tags                           = {
      environment = "dev"
    }
  private_connection_resource_id = module.logicapp.resource.id
  is_manual_connection           = false
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default" 
  # private dns using either from solution accelerator app service or local
  private_dns_zone_group_ids     = [try(local.privatednszone.id, null) == null ? module.private_dns_zones.0.resource.id : local.privatednszone.id ] # [module.private_dns_zones.0.resource.id] #   [module.private_dns_zones.resource.id] 
}

resource "azurerm_user_assigned_identity" "this" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

module "logicapp" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/logic_app/standard"  
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/logic_app/standard"

  # insert the 4 required variables here

  name                         = "${module.naming.logic_app_workflow.name}-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  app_service_plan_id = azurerm_app_service_plan.this.id

  # Required for virtual network integration
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["LogicAppSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["LogicAppSubnet"].resource.id : var.subnet_id 

  identity = {
    type = "UserAssigned" # "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node",
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18",
  }

  # site_config = {
  #   linux_fx_version = "DOCKER|mcr.microsoft.com/azure-functions/dotnet:3.0-appservice"
  # }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "logic app" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  )  


}

