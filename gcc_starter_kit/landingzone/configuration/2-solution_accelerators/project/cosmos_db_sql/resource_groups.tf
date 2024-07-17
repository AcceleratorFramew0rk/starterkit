resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-cosmosdbsql" 
  location = "${try(local.global_settings.location, var.location)}" 
}


