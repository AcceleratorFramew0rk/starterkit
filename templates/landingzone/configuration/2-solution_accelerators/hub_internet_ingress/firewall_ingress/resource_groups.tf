resource "azurerm_resource_group" "this" {
  name     = "${module.naming.resource_group.name}-solution-accelerators-firewall-ingress-internet" 
  location = "${local.global_settings.location}" 
}


