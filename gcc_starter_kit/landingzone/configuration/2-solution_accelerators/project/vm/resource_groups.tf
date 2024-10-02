resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-virtualmachine-${var.virtualmachine_os_type}" 
  location = "${try(local.global_settings.location, var.location)}" 
}


