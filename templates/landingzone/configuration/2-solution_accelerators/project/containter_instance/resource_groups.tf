resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-containergroup" 
  location = "${try(local.global_settings.location, var.location)}" 
}


