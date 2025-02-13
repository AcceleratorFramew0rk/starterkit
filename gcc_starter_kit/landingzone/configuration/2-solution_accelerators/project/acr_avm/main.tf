module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.3.0"

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.azurecr.io"
  tags         = merge(
    local.global_settings.tags,
    {
      purpose = "container registry dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
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
            purpose = "container registry vnet link" 
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
            purpose = "container registry vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "service"   
          }
        )
      }      
    }
}

# This is the module call
module "container_registry" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "0.4.0"

  name                          = replace("${module.naming.container_registry.name}${random_string.this.result}", "-", "") # "${module.naming.container_registry.name_unique}${random_string.this.result}" # module.naming.container_registry.name_unique
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name           = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  public_network_access_enabled = false
  sku                          = "Premium" # ["Basic", "Standard", "Premium"]
  admin_enabled                = true 
  
  diagnostic_settings = {
    log1 = {
      workspace_resource_id    = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id 
    }
  }

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.resource.id] 
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
    }
  }

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "container registry" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 

}
