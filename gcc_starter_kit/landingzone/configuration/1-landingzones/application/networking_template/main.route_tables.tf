resource "azurerm_route_table" "this" {
  name                = module.naming.route_table.name_unique 
  location            = azurerm_resource_group.this.0.location
  resource_group_name = azurerm_resource_group.this.0.name
}

resource "azurerm_route" "this" {

  count = try( local.global_settings.subnets.hub_internet_egress.AzureFirewallSubnet.address_prefixes, null) == null ? 0 : 1

  name                = "${module.naming.route_table.name}-route0" 
  resource_group_name = azurerm_resource_group.this.0.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = "0.0.0.0/0" # all internet traffic
  next_hop_type       = "VirtualAppliance" # ["VirtualNetworkGateway" "VnetLocal" "Internet" "VirtualAppliance" "None"]
  next_hop_in_ip_address = try(cidrhost(local.global_settings.subnets.hub_internet_egress.AzureFirewallSubnet.address_prefixes.0, 4), null)  # egress firewall private ip "100.127.1.4"
}
