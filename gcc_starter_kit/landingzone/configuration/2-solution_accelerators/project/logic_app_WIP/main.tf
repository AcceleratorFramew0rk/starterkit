# add your solution accelerator terraform here.



# # below is an example of container_registry
# module "private_dns_zones" {
#   source                = "Azure/avm-res-network-privatednszone/azurerm"  

#   enable_telemetry      = true
#   resource_group_name   = azurerm_resource_group.this.name
#   domain_name           = "privatelink.azurecr.io"
#   dns_zone_tags         = {
#       env = local.global_settings.environment 
#     }
#   virtual_network_links = {
#       vnetlink1 = {
#         vnetlinkname     = "vnetlink1"
#         vnetid           = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
#         autoregistration = false # true
#         tags = {
#           env = local.global_settings.environment 
#         }
#       }
#     }
# }

# module "container_registry" {
#   source = "./../../../../../../modules/compute/terraform-azurerm-containerregistry"

#   name                         = "${module.naming.container_registry.name}${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
#   resource_group_name          = azurerm_resource_group.this.name
#   location                     = azurerm_resource_group.this.location
#   sku                          = "Premium" # ["Basic", "Standard", "Premium"]
#   admin_enabled                = true 
#   log_analytics_workspace_id   = local.remote.log_analytics_workspace.id 
#   log_analytics_retention_days = 7 
#   tags = { 
#     purpose = "container registry" 
#     project_code = local.global_settings.prefix 
#     env = local.global_settings.environment 
#     zone = "project"
#     tier = "service"           
#   }     
# }

# module "private_endpoint" {
#   source = "./../../../../../../modules/networking/terraform-azurerm-privateendpoint"
  
#   name                           = "${module.container_registry.name}PrivateEndpoint"
#   location                       = azurerm_resource_group.this.location
#   resource_group_name            = azurerm_resource_group.this.name
#   subnet_id                      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceSubnet"].id 
#   tags                           = {
#       environment = "dev"
#     }
#   private_connection_resource_id = module.container_registry.id
#   is_manual_connection           = false
#   subresource_name               = "registry"
#   private_dns_zone_group_name    = "default"
#   private_dns_zone_group_ids     = [module.private_dns_zones.private_dnz_zone_output.id] 
# }

