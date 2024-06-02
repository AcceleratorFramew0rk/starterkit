module "nsg_usernodepoolsubnet" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-usernode" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_usernodepoolsubnet 
}

module "nsg_systemnodepoolsubnet" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-systemnode" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_systemnodepoolsubnet
}

module "nsg_app" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-app" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_app 
}

module "nsg_db" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-db" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_db 
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation1" {
  # count = try(module.virtual_subnet1.subnets["AppSubnet"], null) == null ? 0 : 1
  count = lookup(module.virtual_subnet1.subnets, "AppSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["AppSubnet"].id
  network_security_group_id = module.nsg_app.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_app
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation2" {
  # count = try(module.virtual_subnet1.subnets["SystemNodePoolSubnet"], null) == null ? 0 : 1
  count = lookup(module.virtual_subnet1.subnets, "SystemNodePoolSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["SystemNodePoolSubnet"].id
  network_security_group_id = module.nsg_systemnodepoolsubnet.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_systemnodepoolsubnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation3" {
  # count = try(module.virtual_subnet1.subnets["SystemNodePoolSubnet"], null) == null ? 0 : 1
  count = lookup(module.virtual_subnet1.subnets, "SystemNodePoolSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["UserNodePoolSubnet"].id
  network_security_group_id = module.nsg_usernodepoolsubnet.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_usernodepoolsubnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation4" {
  # count = try(module.virtual_subnet1.subnets["SystemNodePoolSubnet"], null) == null ? 0 : 1
  count = lookup(module.virtual_subnet1.subnets, "SystemNodePoolSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["DbSubnet"].id
  network_security_group_id = module.nsg_db.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_db
  ]
}