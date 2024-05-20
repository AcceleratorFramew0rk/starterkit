resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name 
  location = "${var.location}" 
}

resource "azurerm_resource_group" "gcci_agency_law" {
  name     = local.log_analytics_workspace_resource_group_name 
  location = "${var.location}"
}
