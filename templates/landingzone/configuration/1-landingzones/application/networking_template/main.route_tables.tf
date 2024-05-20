resource "azurerm_route_table" "this" {
  name                = module.naming.route_table.name_unique 
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route" "this" {
  name                = "${module.naming.route_table.name}-route0" 
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0" # all internet traffic
  next_hop_type       = "VirtualAppliance" # ["VirtualNetworkGateway" "VnetLocal" "Internet" "VirtualAppliance" "None"]
  next_hop_in_ip_address = "100.127.1.4" # var.firewall_private_ip  # firewall ip 
}
