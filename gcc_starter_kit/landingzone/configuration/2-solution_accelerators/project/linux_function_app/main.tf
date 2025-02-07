
module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  # count = var.private_dns_zones_enabled ? 1 : 0
  count = try(local.privatednszone.id, null) == null ? 1 : 0   

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.azurewebsites.net"

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "linux function app private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
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
            purpose = "linux function app vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "app"   
          }
        ) 

      }
    }
}

data "azurerm_role_definition" "linux_function_app" {
  name = "Contributor"
}

resource "azurerm_storage_account" "this" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  # name                     = module.naming.storage_account.name_unique
  name = replace(replace(module.naming.storage_account.name_unique, "-", ""), "_", "")
  resource_group_name      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

resource "azurerm_service_plan" "this" {
  location = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  # This will equate to Consumption (Serverless) in portal
  name                = module.naming.app_service_plan.name_unique
  os_type             = "Windows" # "Linux"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  sku_name            = "EP1"
}

resource "azurerm_user_assigned_identity" "user" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

module "linux_function_app" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.1.0"

  enable_telemetry = var.enable_telemetry 
  name                = "${module.naming.function_app.name}-${random_string.this.result}"  # module.naming.function_app.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  os_type = azurerm_service_plan.this.os_type
  service_plan_resource_id = azurerm_service_plan.this.id
  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  public_network_access_enabled = false
  managed_identities = {
    # Identities can only be used with the Standard SKU

    /*
    system = {
      identity_type = "SystemAssigned"
      identity_ids = [ azurerm_user_assigned_identity.system.id ]
    }
    */

    user = {
      identity_type = "UserAssigned"
      identity_ids  = [azurerm_user_assigned_identity.user.id]
    }

    /*
    system_and_user = {
      identity_type = "SystemAssigned, UserAssigned"
      identity_resource_ids = [
        azurerm_user_assigned_identity.user.id
      ]
    }
    */
  }

  lock = {
    kind = "None"
    /*
    kind = "ReadOnly"
    */
    /*
    kind = "CanNotDelete"
    */
  }

  private_endpoints = {
    # Use of private endpoints requires Standard SKU
    primary = {
      name                          = "primary-interfaces"
      # private_dns_zone_resource_ids =  [try(var.private_dns_zones_id, null) != null ? var.private_dns_zones_id : module.private_dns_zones[0].resource.id] 
      private_dns_zone_resource_ids =  [try(local.privatednszone.id, null) == null ? module.private_dns_zones[0].resource.id : local.privatednszone.id ]

      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.subnet_id 
      inherit_lock = true
      inherit_tags = true
      lock = {
        /*
        kind = "None"
        */
        /*
        kind = "ReadOnly"
        */
        /*
        kind = "CanNotDelete"
        */
      }

      role_assignments = {
        role_assignment_1 = {
          role_definition_id_or_name = data.azurerm_role_definition.linux_function_app.id
          principal_id               = data.azurerm_client_config.current.object_id
        }
      }

      tags = {
        webapp = "${module.naming.static_web_app.name_unique}-interfaces"
      }

    }

  }

  role_assignments = {
    role_assignment_1 = {
      role_definition_id_or_name = data.azurerm_role_definition.linux_function_app.id
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  diagnostic_settings = {
    diagnostic_settings_1 = {
      name                  = "dia_settings_1"
      workspace_resource_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id 
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "linux function app" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

}


