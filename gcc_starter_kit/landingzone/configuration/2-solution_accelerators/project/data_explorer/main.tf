module "data_explorer" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/data-explorer"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/data-explorer"

  name                     = "${module.naming.kusto_cluster.name}-iot-${random_string.this.result}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  sku_name                 = "Standard_D13_v2" # Standard_L8as_v3
  sku_capacity             = 4 # 2


  tags = merge(
    local.global_settings.tags,
    {
      purpose = "data explorer" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.kusto.windows.net"
  tags         = merge(
    local.global_settings.tags,
    {
      purpose = "data explorer private dns zone" 
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
            purpose = "data explorer vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "service"   
          }
        )
      }
    
    }
}


module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

  name                           = "${module.naming.kusto_cluster.name}-iot-${random_string.this.result}privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "data explorer private endpoint" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
  private_connection_resource_id = module.data_explorer.resource.id
  is_manual_connection           = false
  subresource_name               = "cluster" 
  private_dns_zone_group_name    = "default"
  private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
  
  depends_on = [
    module.data_explorer, 
    module.private_dns_zones
  ]

}
