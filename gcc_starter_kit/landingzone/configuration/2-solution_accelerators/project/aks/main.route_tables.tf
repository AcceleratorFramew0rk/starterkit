# resource "azurerm_route_table" "this" {
#   name                = module.naming.route_table.name_unique # "acceptanceTestRouteTable1"
#   location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
#   resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
# }

# resource "azurerm_route" "this" {
#   name                = "${module.naming.route_table.name}-route0" # "acceptanceTestRoute1"
#   resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
#   route_table_name    = azurerm_route_table.this.name
#   address_prefix      = "0.0.0.0/0"
#   next_hop_type       = "VirtualAppliance" # "VnetLocal"
#   next_hop_in_ip_address = "100.127.1.0"
# }

# # TODO: add subnets azurerm_subnet_route_table_association
# resource "azurerm_subnet_route_table_association" "hub_gateway" {
#   subnet_id      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets["SystemNodePoolSubnet"].resource.id 
#   route_table_id = azurerm_route_table.this.id

#   depends_on = ["azurerm_route_table.this"]
# }