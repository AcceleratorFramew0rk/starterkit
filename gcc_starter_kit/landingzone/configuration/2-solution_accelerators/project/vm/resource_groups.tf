resource "azurerm_resource_group" "this" {
  count = try(local.global_settings.resource_group_name, null) == null ? 1 : 0
  
  name = lower("${module.naming.resource_group.name}-solution-accelerators-${var.vnet_type}virtualmachine-${var.virtualmachine_os_type}")
  location = "${try(local.global_settings.location, var.location)}" 
}


