resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-mssql" 
  location = local.global_settings.location 
}


