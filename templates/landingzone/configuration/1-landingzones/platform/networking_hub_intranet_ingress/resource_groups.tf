resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-network-hub-intranet-ingress" 
  location = "${local.global_settings.location}" 
}


