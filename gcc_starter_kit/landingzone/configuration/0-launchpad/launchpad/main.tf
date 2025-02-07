# vnets:
#   # IMPORTANT: leave empty if there is no such virtual network   
#   ingress_internet: "gcci-vnet-ingress-internet"   
#   egress_internet: "gcci-vnet-egress-internet"  
#   ingress_intranet: "gcci-vnet-ingress-intranet" 
#   egress_intranet: "gcci-vnet-egress-intranet"  
#   project: "gcci-vnet-project"   
#   management: "gcci-vnet-management"   
#   devops: "gcci-vnet-devops"   
# USAGE:
# local.globalsettings.vnets.ingress_internet
# local.globalsettings.vnets.egress_internet


resource "azurerm_resource_group" "gcci_platform" {
  name = try(local.globalsettings.config.resource_group_name, null) != null ? local.globalsettings.config.resource_group_name : "gcci-platform"
}

resource "azurerm_resource_group" "gcci_agency_law" {
  name = try(local.globalsettings.config.log_analytics_workspace_resource_group_name, null) != null ? local.globalsettings.config.log_analytics_workspace_resource_group_name : "gcci-agency-law"
}

resource "azurerm_virtual_network" "gcci_vnet_ingress_internet" {
  name = local.globalsettings.vnets.hub_ingress_internet # "gcci-vnet-ingress-internet" 
}

resource "azurerm_virtual_network" "gcci_vnet_egress_internet" {
  name = local.globalsettings.vnets.hub_egress_internet # "gcci-vnet-egress-internet" 
}

resource "azurerm_virtual_network" "gcci_vnet_ingress_intranet" {
  name = local.globalsettings.vnets.hub_ingress_intranet # "gcci-vnet-ingress-intranet" 
}

resource "azurerm_virtual_network" "gcci_vnet_egress_intranet" {
  name = local.globalsettings.vnets.hub_egress_intranet # "gcci-vnet-egress-intranet" 
}

resource "azurerm_virtual_network" "gcci_vnet_project" {
  name = local.globalsettings.vnets.project # "gcci-vnet-project" 
}

resource "azurerm_virtual_network" "gcci_vnet_management" {
  name = local.globalsettings.vnets.management # "gcci-vnet-management" 
}

resource "azurerm_virtual_network" "gcci_vnet_devops" {
  name = local.globalsettings.vnets.devops # "gcci-vnet-devops" 
}

resource "azurerm_log_analytics_workspace" "gcci_agency_workspace" {
  name = try(local.globalsettings.config.log_analytics_workspace_name, null) != null ? local.globalsettings.config.log_analytics_workspace_name : "gcci-agency-workspace"
}

