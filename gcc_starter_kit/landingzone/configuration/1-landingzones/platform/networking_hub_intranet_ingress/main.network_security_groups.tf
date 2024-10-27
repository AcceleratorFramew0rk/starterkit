module "network_security_groups" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = lower("${module.naming.network_security_group.name}-agw") # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules      = local.config["IntranetAgwSubnet"]

}


