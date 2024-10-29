# module "private_dns_zones" {
#   source                = "Azure/avm-res-network-privatednszone/azurerm"  
#   version = "0.1.2"

#   enable_telemetry      = true
#   resource_group_name   = azurerm_resource_group.this.name
#   domain_name           = "privatelink.azure-devices.net"
#   tags         = merge(
#     local.global_settings.tags,
#     {
#       purpose = "iot hub private dns zone" 
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
#             purpose = "iot hub vnet link" 
#             project_code = try(local.global_settings.prefix, var.prefix) 
#             env = try(local.global_settings.environment, var.environment) 
#             zone = "project"
#             tier = "service"   
#           }
#         )
#       }
    
#     }
# }


# ```
# Basic Usgae:
# ```
# module "eventhubs" {
#   source = "../modules/azurerm_eventhubs"
#   resource_group_name =  "eventhubs-resources"
#   location =  "East Asia"
#   name = "sampleiotapp"
#   sku_name = "S1"
#   sku_capacity = "1"

#   tags = {
#       name = "eventhubs"
#       environment =  "Development"
#   }

# }

module "event_hubs" {
  source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/event-hubs"
  # source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/event_hubs" 

  name                         = "${module.naming.eventhub.name_unique}${random_string.this.result}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location

  namespace_name      = "iotehnamespace"
  partition_count     = 4
  message_retention   = 7

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "event hubs" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = ""   
    }
  ) 
}

# module "private_endpoint" {
#   # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
#   source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

#   name                           = "${module.iot_hub.name}PrivateEndpoint"
#   location                       = azurerm_resource_group.this.location
#   resource_group_name            = azurerm_resource_group.this.name
#   subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.subnet_id 
#   tags                           = merge(
#     local.global_settings.tags,
#     {
#       purpose = "iot hub private endpoint" 
#       project_code = try(local.global_settings.prefix, var.prefix) 
#       env = try(local.global_settings.environment, var.environment) 
#       zone = "project"
#       tier = "service"   
#     }
#   ) 
#   private_connection_resource_id = module.iot_hub.id
#   is_manual_connection           = false
#   subresource_name               = "eventhubs" # ["eventhubs"] # "registry"
#   private_dns_zone_group_name    = "eventhubssPrivateDnsZoneGroup"
#   private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
# }

