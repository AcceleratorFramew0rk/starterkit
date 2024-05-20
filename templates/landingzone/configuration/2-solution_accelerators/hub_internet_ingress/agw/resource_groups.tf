resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-agw-internet" 
  location = "${local.global_settings.location}" 
}


