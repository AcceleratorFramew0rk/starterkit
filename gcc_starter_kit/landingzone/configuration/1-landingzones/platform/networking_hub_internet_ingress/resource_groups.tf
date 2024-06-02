resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-network-hub-internet-ingress" 
  location = "${local.global_settings.location}" 
}


