
output "global_settings" {
  value = local.global_settings
  description = "The framework global_settings"
}

output "gcci_platform" {
  value       = azurerm_resource_group.this
  description = "The Azure Virtual Network resource"
}

output "gcci_agency_law" {
  value = azurerm_resource_group.gcci_agency_law
  description = "The resource group for gcci agency law"
}

output "hub_internet_ingress" {
  value       = try(module.virtualnetwork_hub_internet_ingress[0].resource, null)  # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "hub_internet_egress" {
  value       = try(module.virtualnetwork_hub_internet_egress[0].resource, null)  # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "hub_intranet_ingress" {
  value       = try(module.virtualnetwork_hub_intranet_ingress[0].resource, null)  # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "hub_intranet_egress" {
  value       = try(module.virtualnetwork_hub_intranet_egress[0].resource, null)  # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "spoke_project" {
  value       = try(module.virtualnetwork_project[0].resource, null)  # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "spoke_management" {
  value       = try(module.virtualnetwork_management[0].resource, null)  # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "spoke_devops" {
  value       = try(module.virtualnetwork_devops[0].resource, null) # azurerm_virtual_network.vnet
  description = "The Azure Virtual Network resource"
}

output "gcci_agency_workspace" {
  value       = {
    name = module.log_analytics_workspace.name 
    id = module.log_analytics_workspace.id
    resource = module.log_analytics_workspace
  }
  description = "The Azure Virtual Network resource"
}

