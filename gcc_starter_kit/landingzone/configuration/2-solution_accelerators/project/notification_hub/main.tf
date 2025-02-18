module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.3.0"

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.servicebus.windows.net"
  tags         = merge(
    local.global_settings.tags,
    {
      purpose = "notification hub dns zone" 
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
            purpose = "notification hub vnet link" 
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
resource "azurerm_notification_hub_namespace" "this" {
  name                = "${module.naming.notification_hub_namespace.name}-${random_string.this.result}"
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name           = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  namespace_type      = "NotificationHub"

  sku_name = "Free"


  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "notification hub namespace" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 

}

resource "azurerm_notification_hub" "this" {
  name                = "${module.naming.notification_hub.name}-${random_string.this.result}"
  namespace_name      = azurerm_notification_hub_namespace.this.name
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name           = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name

  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "notification hub" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
}


module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

  name                           = "${azurerm_notification_hub_namespace.this.name}privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "notification hub private endpoint" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
  private_connection_resource_id = azurerm_notification_hub_namespace.this.id
  is_manual_connection           = false
  subresource_name               = "namespace"
  private_dns_zone_group_name    = "Default"
  private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
}


