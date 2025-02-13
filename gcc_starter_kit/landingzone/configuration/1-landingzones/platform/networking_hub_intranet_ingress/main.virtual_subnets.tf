module "virtual_subnet1" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.2.3"

  for_each = try(var.subnets.hub_intranet_ingress, null) == null ? local.global_settings.subnets.hub_intranet_ingress : var.subnets.hub_intranet_ingress

  virtual_network                               = { resource_id = local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_network.id }
  name                                          = each.value.name
  address_prefixes                              = each.value.address_prefixes
  delegation                                    = try(each.value.delegations, null)
  # default_outbound_access_enabled               = try(each.value.default_outbound_access_enabled, null)
  # nat_gateway                                   = try(each.value.nat_gateway, null)
  # network_security_group                        = try(each.value.network_security_group, null)
  # private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, null)
  # private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)
  # route_table                                   = try(each.value.route_table, null)
  # service_endpoints                             = try(each.value.service_endpoints, null)
  # service_endpoint_policies                     = try(each.value.service_endpoint_policies, null)
  # role_assignments                              = try(each.value.role_assignments, null)

  network_security_group                        = try(each.value.name, null) == "AzureFirewallSubnet" ? null :  try(module.network_security_groups[each.value.name].resource, null)

  depends_on = [
    module.network_security_groups,
  ]
}

