
# module "data_explorer_job" {
#   source              = "../"
#   basename            = random_string.postfix.result
#   resource_group_name = module.local_rg.name
#   location            = var.location
#   tags                = {}
# }

module "data_explorer" {
  source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/data-explorer"
  # source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/data-explorer"

  # name                         = "${module.naming.iothub.name_unique}${random_string.this.result}"
  name                     = "${module.naming.kusto_cluster.name_unique}${random_string.this.result}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  sku_name                 = "Standard_D13_v2"
  sku_capacity             = 4


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

