# Creating Subnets within the Virtual Network.
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  address_prefixes                              = each.value.address_prefixes
  name                                          = each.key
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name 
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
  service_endpoints                             = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegations == null ? [] : each.value.delegations

    content {
      name = delegation.value.name 

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions 
      }
    }
  }

}
