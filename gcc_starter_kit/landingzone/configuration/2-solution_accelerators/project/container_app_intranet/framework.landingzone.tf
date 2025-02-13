#-------------------------------------------------------------------------------
# ** IMPORTANT: DO NOT CHANGE
#-------------------------------------------------------------------------------
# Example usage
# vnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
# vnet_name = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
# subnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id 
# subnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id 
# subnet_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AppSubnet"].resource.id 
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

  resource_group_name  = var.resource_group_name 
  storage_account_name = var.storage_account_name 
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

# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

# local remote variables
locals {
  global_settings = try(module.landingzone.global_settings, null)   
  remote =  try(module.landingzone.remote, null)   
} 
