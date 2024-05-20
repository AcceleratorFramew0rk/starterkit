resource "azurerm_route_table" "this" {
  name                = module.naming.route_table.name_unique # "acceptanceTestRouteTable1"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route" "this" {
  name                = "${module.naming.route_table.name}-route0" 
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance" 
  next_hop_in_ip_address = "100.127.1.0" # TODO: Change to IP Address of egress firewall
}

resource "azurerm_subnet_route_table_association" "hub_gateway" {
  subnet_id      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["SystemNodePoolSubnet"].id 
  route_table_id = azurerm_route_table.this.id

  depends_on = ["azurerm_route_table.this"]
}