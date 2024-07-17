module "nsg1" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-mgmtinfra" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_management_infra  
}

module "nsg2" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-mgmtbastion" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_management_bastion  
}

module "nsg3" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-mgmtsecurity" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_management_security  
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation1" {
  count = lookup(module.virtual_subnet1, "InfraSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["InfraSubnet"].resource.id
  network_security_group_id = module.nsg1.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg1
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation2" {
  count = lookup(module.virtual_subnet1, "AzureBastionSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["AzureBastionSubnet"].resource.id
  network_security_group_id = module.nsg2.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg2
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation3" {
  count = lookup(module.virtual_subnet1, "SecuritySubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["SecuritySubnet"].resource.id
  network_security_group_id = module.nsg3.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg3
  ]
}

