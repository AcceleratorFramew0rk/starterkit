# internet ingress - project
resource "azurerm_virtual_network_peering" "internet_ingress_peer_project" {
  
  count = try(local.remote.networking.virtual_networks.hub_internet_ingress.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}internet-ingress-peer-project" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.hub_internet_ingress.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "project_peer_internet_ingress" {

  count = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.hub_internet_ingress.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}project-peer-internet-ingress" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.hub_internet_ingress.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

# internet egress - project
resource "azurerm_virtual_network_peering" "internet_egress_peer_project" {

  count = try(local.remote.networking.virtual_networks.hub_internet_egress.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}internet-egress-peer-project" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.hub_internet_egress.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "project_peer_internet_egress" {

  count = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.hub_internet_egress.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}project-peer-internet-egress" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.hub_internet_egress.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

# intranet ingress - project
resource "azurerm_virtual_network_peering" "intranet_ingress_peer_project" {

  count = try(local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}intranet-ingress-peer-project" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "project_peer_intranet_ingress" {

  count = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}project-peer-intranet-ingress" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

# intranet egress - project
resource "azurerm_virtual_network_peering" "intranet_egress_peer_project" {

  count = try(local.remote.networking.virtual_networks.hub_intranet_egress.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}intranet-egress-peer-project" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.hub_intranet_egress.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "project_peer_intranet_egress" {

  count = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.hub_intranet_egress.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}project-peer-intranet-egress" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.hub_intranet_egress.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}
# management - project
resource "azurerm_virtual_network_peering" "management_peer_project" {

  count = try(local.remote.networking.virtual_networks.spoke_management.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}management-peer-project" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_management.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "project_peer_management" {

  count = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_management.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}project-peer-management" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_project.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_management.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

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


# devops - management
resource "azurerm_virtual_network_peering" "devops_peer_management" {

  count = try(local.remote.networking.virtual_networks.spoke_devops.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_management.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}devops-peer-management" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_devops.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_management.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}

resource "azurerm_virtual_network_peering" "management_peer_devops" {

  count = try(local.remote.networking.virtual_networks.spoke_management.virtual_network.name, null) != null && try(local.remote.networking.virtual_networks.spoke_devops.virtual_network.id, null) != null ? 1 : 0

  name                         = "${module.naming.virtual_network_peering.name}${random_string.this.result}management-peer-devops" 
  resource_group_name          = local.remote.resource_group.name
  virtual_network_name         = local.remote.networking.virtual_networks.spoke_management.virtual_network.name  
  remote_virtual_network_id    = local.remote.networking.virtual_networks.spoke_devops.virtual_network.id  
  allow_virtual_network_access = true 
  allow_forwarded_traffic      = true 
  allow_gateway_transit        = false
  use_remote_gateways          = false 
}
