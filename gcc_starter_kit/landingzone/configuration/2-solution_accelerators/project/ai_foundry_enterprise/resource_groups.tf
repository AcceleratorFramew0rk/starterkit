resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-ai"  # "name" may not exceed 90 characters in length
  location = "${try(local.global_settings.location, var.location)}" 
}


