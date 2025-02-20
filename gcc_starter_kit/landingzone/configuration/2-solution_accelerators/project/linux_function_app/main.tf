
module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

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
  name = replace(replace("${module.naming.storage_account.name_unique}${random_string.this.result}fa", "-", ""), "_", "")
  resource_group_name      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

resource "azurerm_service_plan" "this" {
  location = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  # This will equate to Consumption (Serverless) in portal
  name                = module.naming.app_service_plan.name_unique
  os_type             = "Linux" # "Windows"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  sku_name            = "EP1"
}

resource "azurerm_user_assigned_identity" "user" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}


# This is the module call
module "linux_function_app" {
  source  = "Azure/avm-res-web-site/azurerm"
  # version = "0.1.0"
  version = "0.9.0"  
  # version = "0.14.2" # required terrform version 1.9

  enable_telemetry = var.enable_telemetry

  name                = "${module.naming.function_app.name}-${random_string.this.result}"  # module.naming.function_app.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  kind    = "functionapp"
  os_type = azurerm_service_plan.this.os_type
  service_plan_resource_id = azurerm_service_plan.this.id
  function_app_storage_account_name       = azurerm_storage_account.this.name
  function_app_storage_account_access_key = azurerm_storage_account.this.primary_access_key  
  public_network_access_enabled = false
  virtual_network_subnet_id  = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
  https_only                 = true


  managed_identities = {
    # Identities can only be used with the Standard SKU    
    system_assigned = true
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.user.id
    ]
  }

  enable_application_insights = true

  application_insights = {
    name                  = module.naming.application_insights.name_unique
    resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
    location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
    application_type      = "web"
    workspace_resource_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
    tags        = merge(
      local.global_settings.tags,
      {
        purpose = "linux function app application insight" 
        project_code = try(local.global_settings.prefix, var.prefix) 
        env = try(local.global_settings.environment, var.environment) 
        zone = "project"
        tier = "app"   
      }
    ) 
  }

  site_config = var.site_config

  functions_extension_version = "~4"

    # "APPINSIGHTS_INSTRUMENTATIONKEY"                             = azurerm_application_insights.main.instrumentation_key
    # "APPLICATIONINSIGHTS_CONNECTION_STRING"                      = azurerm_application_insights.main.connection_string
    # "STORAGE_ACCOUNT_CONNECTION_STRING"                          = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.storage_account_connection_string_secret_name})"
    # "STORAGE_CONTAINER_NAME"                                     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.storage_container_secret_name})"
    # "DOCKER_REGISTRY_SERVER_URL"                                 = azurerm_container_registry.main.login_server
    # "DOCKER_CUSTOM_IMAGE_NAME"                                   = "DOCKER|${azurerm_container_registry.main.login_server}/${var.IMAGE_NAME}:${var.image_tag}"
  app_settings = {
    "AzureWebJobsStorage"                                        = azurerm_storage_account.this.primary_connection_string
    "AzureWebJobsDashboard"                                      = azurerm_storage_account.this.primary_connection_string
    "WEBSITE_LOGGING_LOG_LEVEL"                                  = "Information"
    "AzureFunctionsJobHost__Logging__Console__IsEnabled"         = "true"
    "AzureFunctionsJobHost__Logging__Console__LogLevel__Default" = "Information"
    "SCALE_CONTROLLER_LOGGING_ENABLED"                           = "AppInsights:Verbose"
    "DOCKER_ENABLE_CI"                                           = true
    "FUNCTIONS_EXTENSION_VERSION"                                = "~4"
    "DOCKER_REGISTRY_SERVER_USERNAME"                            = null
    "DOCKER_REGISTRY_SERVER_PASSWORD"                            = null
    "WEBSITE_WEBDEPLOY_USE_SCM"                                  = true
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"                        = false
  }

  private_endpoints = {
    # Use of private endpoints requires Standard SKU
    primary = {
      name                          = "primary-interfaces"
      private_dns_zone_resource_ids =  [try(local.privatednszone.id, null) == null ? module.private_dns_zones[0].resource.id : local.privatednszone.id ]

      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_subnet_name].resource.id : var.ingress_subnet_id 
      inherit_lock = true
      inherit_tags = true
      # lock = {
      #   /*
      #   kind = "None"
      #   */
      #   /*
      #   kind = "ReadOnly"
      #   */
      #   /*
      #   kind = "CanNotDelete"
      #   */
      # }

      role_assignments = {
        role_assignment_1 = {
          role_definition_id_or_name = data.azurerm_role_definition.linux_function_app.id
          principal_id               = data.azurerm_client_config.current.object_id
        }
      }


      tags        = merge(
        local.global_settings.tags,
        {
          purpose = "linux function app private endpoint" 
          project_code = try(local.global_settings.prefix, var.prefix) 
          env = try(local.global_settings.environment, var.environment) 
          zone = "project"
          tier = "app"   
        }
      ) 

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
      name                  = "${module.naming.monitor_diagnostic_setting.name_unique}-funcapp"
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

