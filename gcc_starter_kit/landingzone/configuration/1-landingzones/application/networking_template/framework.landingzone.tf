#-------------------------------------------------------------------------------
# ** IMPORTANT: DO NOT CHANGE
#-------------------------------------------------------------------------------
# Example usage
# vnet_id = local.remote.networking.virtual_networks.hub_internet.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.hub_internet.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.hub_intranet.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.hub_intranet.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.spoke_devops.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_devops.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.spoke_management.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_management.virtual_network.name  
# vnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
# log_analytics_workspace_id = local.remote.log_analytics_workspace.id 
# resource_group_name = local.remote.resource_group.name  
#-------------------------------------------------------------------------------
variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "resource_group_name" {
  type        = string
}

variable "storage_account_name" {
  type        = string
}

module "landingzone" {
  # source="./../../../../../../modules/terraform-azurerm-aaf"
  source = "AcceleratorFramew0rk/aaf/azurerm"

  resource_group_name  = var.resource_group_name # "wx2-dev-sea-rg-launchpad" # DO NOT CHANGE - codegen
  storage_account_name = var.storage_account_name # "wx2devseastgtfstatekvy" # DO NOT CHANGE - codegen 
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  prefix = local.global_settings.is_prefix == true ? ["${try(local.global_settings.prefix, var.prefix)}"] : []
  suffix = local.global_settings.is_prefix == true ? [] : ["${try(local.global_settings.prefix, var.prefix)}"] 
  unique-seed            = "random"
  unique-length          = 3
  unique-include-numbers = false  
}

data "azurerm_client_config" "current" {}

# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

# local remote variables
locals {
  global_settings = module.landingzone.global_settings   
  remote =  module.landingzone.remote # remote virtual networks resources   
} 
