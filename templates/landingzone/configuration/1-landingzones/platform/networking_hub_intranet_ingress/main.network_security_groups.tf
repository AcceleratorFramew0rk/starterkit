module "nsg1" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.1.1"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-intranetagw"
  location            = local.global_settings.location
  nsgrules            = local.config.nsg_intranet_agw  # var.rules_agwsubnet
}

resource "azurerm_subnet_network_security_group_association" "AgwSubnet1" {
  count = lookup(module.virtual_subnet1.subnets, "AgwSubnet", null) == null ? 0 : 1
    
  subnet_id                 = module.virtual_subnet1.subnets["AgwSubnet"].id
  network_security_group_id = module.nsg1.nsg_resource.id

  depends_on = [
    module.virtual_subnet1,
    # module.virtual_subnet2,
    module.nsg1
  ]
}
