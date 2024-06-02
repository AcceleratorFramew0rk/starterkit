resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-azureopenai" 
  location = "${try(local.global_settings.location, var.location)}" 
}

resource "azurerm_resource_group" "eastus" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-azureopenai-eastus" 
  location = "eastus" 
}



