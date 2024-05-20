
module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.azurewebsites.net"
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

data "azurerm_role_definition" "linux_function_app" {
  name = "Contributor"
}

resource "azurerm_storage_account" "this" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.this.location
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.this.name
}

resource "azurerm_service_plan" "this" {
  location = azurerm_resource_group.this.location
  # This will equate to Consumption (Serverless) in portal
  name                = module.naming.app_service_plan.name_unique
  os_type             = "Windows" # "Linux"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "EP1"
}

resource "azurerm_user_assigned_identity" "user" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = azurerm_resource_group.this.name
}

module "linux_function_app" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.1.0"

  enable_telemetry = var.enable_telemetry 
  name                = "${module.naming.function_app.name}${random_string.this.result}"  # module.naming.function_app.name_unique
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
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
      private_dns_zone_resource_ids =  [module.private_dns_zones.private_dnz_zone_output.id] 
      subnet_resource_id            = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["FunctionAppSubnet"].id 
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
      workspace_resource_id = local.remote.log_analytics_workspace.id 
    }
  }

  tags = { 
    purpose = "linux function app" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "app"           
  } 

}


