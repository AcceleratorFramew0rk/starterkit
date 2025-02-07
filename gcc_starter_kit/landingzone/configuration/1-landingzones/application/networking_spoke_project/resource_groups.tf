# resource "azurerm_resource_group" "this" {
#   name     = "${module.naming.resource_group.name}-network-spoke-project" 
#   location = "${local.global_settings.location}" 
# }


resource "azurerm_resource_group" "this" {
  count = try(local.global_settings.resource_group_name, null) == null ? 1 : 0

  name     = "${module.naming.resource_group.name}-network-spoke-project"
  location = local.global_settings.location
}
