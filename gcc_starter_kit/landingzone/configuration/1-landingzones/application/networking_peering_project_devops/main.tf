# devops - project
resource "azurerm_virtual_network_peering" "devops_peer_project" {

  count = try(local.remote.networking.virtual_networks.spoke_devops.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}devops-peer-project" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_devops.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "project_peer_devops" {

  count = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_devops.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}project-peer-devops" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_devops.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}
