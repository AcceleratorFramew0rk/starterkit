module "nsg1" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.1.1"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-runner" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  nsgrules            = local.config.nsg_devops_runner  # var.rule1
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation1" {
  count = lookup(module.virtual_subnet1.subnets, "RunnerSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["RunnerSubnet"].id
  network_security_group_id = module.nsg1.nsg_resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg1
  ]
}
