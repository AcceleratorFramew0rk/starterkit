resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-network-spoke-project" 
  location = "${local.global_settings.location}" 
}


