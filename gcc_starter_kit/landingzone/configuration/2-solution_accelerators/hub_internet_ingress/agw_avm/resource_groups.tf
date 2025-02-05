resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-agwavm-internet" 
  location = "${local.global_settings.location}" 
}


