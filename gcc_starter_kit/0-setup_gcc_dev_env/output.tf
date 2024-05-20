
output "gcci_platform" {
  value       = azurerm_resource_group.this
  description = "The Azure Virtual Network resource"
}

output "gcci_agency_law" {
  value = azurerm_resource_group.gcci_agency_law
  description = "The resource group for gcci agency law"
}

output "hub_internet_ingress" {
  value       = module.virtualnetwork_hub_internet_ingress.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "hub_internet_egress" {
  value       = module.virtualnetwork_hub_internet_egress.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "hub_intranet_ingress" {
  value       = module.virtualnetwork_hub_intranet_ingress.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "hub_intranet_egress" {
  value       = module.virtualnetwork_hub_intranet_egress.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "spoke_project" {
  value       = module.virtualnetwork_project.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "spoke_management" {
  value       = module.virtualnetwork_management.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "spoke_devops" {
  value       = module.virtualnetwork_devops.vnet-resource # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "gcci_agency_workspace" {
  value       = {
    name = module.log_analytics_workspace.name # azurerm_virtual_network.vnet
    id = module.log_analytics_workspace.id
  }
  description = "The Azure Virtual Network resource"
}

