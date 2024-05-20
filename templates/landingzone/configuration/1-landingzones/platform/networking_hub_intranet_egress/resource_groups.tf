resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-network-hub-intranet-egress" 
  location = "${local.global_settings.location}" 
}


