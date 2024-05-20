output "global_settings" {
  value = local.global_settings
  description = "The framework global_settings"
}

output "gcci_platform" {
  value = azurerm_resource_group.gcci_platform
  description = "The resource group for gcci platform"
}

output "gcci_agency_law" {
  value = azurerm_resource_group.gcci_agency_law
  description = "The resource group for gcci agency law"
}

output "hub_internet_ingress" {
  value = azurerm_virtual_network.gcci_vnet_ingress_internet
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "hub_internet_egress" {
  value = azurerm_virtual_network.gcci_vnet_egress_internet
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "hub_intranet_ingress" {
  value = azurerm_virtual_network.gcci_vnet_ingress_intranet
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "hub_intranet_egress" {
  value = azurerm_virtual_network.gcci_vnet_egress_intranet
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "spoke_project" {
  value = azurerm_virtual_network.gcci_vnet_project
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "spoke_management" {
  value = azurerm_virtual_network.gcci_vnet_management
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "spoke_devops" {
  value = azurerm_virtual_network.gcci_vnet_devops
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}

output "gcci_agency_workspace" {
  value = {
    id = azurerm_log_analytics_workspace.gcci_agency_workspace.id
    name = azurerm_log_analytics_workspace.gcci_agency_workspace.name
  }
  description = "The virtual network gcci_vnet_ingress_internet for gcci platform"
}



