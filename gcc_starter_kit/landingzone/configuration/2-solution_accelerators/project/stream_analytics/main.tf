
# module "data_explorer_job" {
#   source              = "../"
#   basename            = random_string.postfix.result
#   resource_group_name = module.local_rg.name
#   location            = var.location
#   tags                = {}
# }

module "stream_analytics" {
  source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/stream-analytics"
  # source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/stream-analyticss/stream-analytics-job" 

  # name                         = "${module.naming.iothub.name_unique}${random_string.this.result}"
  name                     = "${module.naming.stream_analytics_job.name_unique}${random_string.this.result}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location

  iot_hub_id = local.iothub.resource.id
  data_explorer_id = local.dataexplorer.resource.id
  event_hub_id = local.eventhubs.resource.id
  # sql_server_id = local.sqlserver.id

 
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

# module "private_dns_zones" {
#   source                = "Azure/avm-res-network-privatednszone/azurerm"  
#   version = "0.1.2"

#   enable_telemetry      = true
#   resource_group_name   = azurerm_resource_group.this.name
#   domain_name           = "privatelink.azure-devices.net"
#   tags         = merge(
#     local.global_settings.tags,
#     {
#       purpose = "data explorer private dns zone" 
#       project_code = try(local.global_settings.prefix, var.prefix) 
#       env = try(local.global_settings.environment, var.environment) 
#       zone = "project"
#       tier = "service"   
#     }
#   )
#   virtual_network_links = {
#       vnetlink1 = {
#         vnetlinkname     = "vnetlink1"
#         vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
#         autoregistration = false # true
#         tags = merge(
#           local.global_settings.tags,
#           {
#             purpose = "data explorer vnet link" 
#             project_code = try(local.global_settings.prefix, var.prefix) 
#             env = try(local.global_settings.environment, var.environment) 
#             zone = "project"
#             tier = "service"   
#           }
#         )
#       }
    
#     }
# }



# module "private_endpoint" {
#   # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
#   source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

#   name                           = "${module.container_registry.name}PrivateEndpoint"
#   location                       = azurerm_resource_group.this.location
#   resource_group_name            = azurerm_resource_group.this.name
#   subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.subnet_id 
#   tags                           = merge(
#     local.global_settings.tags,
#     {
#       purpose = "data explorer private endpoint" 
#       project_code = try(local.global_settings.prefix, var.prefix) 
#       env = try(local.global_settings.environment, var.environment) 
#       zone = "project"
#       tier = "service"   
#     }
#   ) 
#   private_connection_resource_id = module.data_explorer.id
#   is_manual_connection           = false
#   subresource_name               = "registry"
#   private_dns_zone_group_name    = "iothubsPrivateDnsZoneGroup"
#   private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
# }

