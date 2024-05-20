resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-keyvault" 
  location = "${local.global_settings.location}" 
}


