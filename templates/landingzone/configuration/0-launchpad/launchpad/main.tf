resource "azurerm_resource_group" "gcci_platform" {
  name = "gcci-platform"
}

resource "azurerm_resource_group" "gcci_agency_law" {
  name = "gcci-agency-law"
}

resource "azurerm_virtual_network" "gcci_vnet_ingress_internet" {
  name = "gcci-vnet-ingress-internet" 
}

resource "azurerm_virtual_network" "gcci_vnet_egress_internet" {
  name = "gcci-vnet-egress-internet" 
}

resource "azurerm_virtual_network" "gcci_vnet_ingress_intranet" {
  name = "gcci-vnet-ingress-intranet" 
}

resource "azurerm_virtual_network" "gcci_vnet_egress_intranet" {
  name = "gcci-vnet-egress-intranet" 
}

resource "azurerm_virtual_network" "gcci_vnet_project" {
  name = "gcci-vnet-project" 
}

resource "azurerm_virtual_network" "gcci_vnet_management" {
  name = "gcci-vnet-management" 
}

resource "azurerm_virtual_network" "gcci_vnet_devops" {
  name = "gcci-vnet-devops" 
}

resource "azurerm_log_analytics_workspace" "gcci_agency_workspace" {
  name = "gcci-agency-workspace"
}

