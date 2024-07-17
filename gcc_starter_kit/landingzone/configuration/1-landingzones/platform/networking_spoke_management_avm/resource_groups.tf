resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-network-spoke-management" 
  location = "${local.global_settings.location}" 
}


