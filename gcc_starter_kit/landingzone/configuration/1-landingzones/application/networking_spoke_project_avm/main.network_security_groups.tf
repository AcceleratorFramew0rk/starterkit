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

module "nsg_api" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-api" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_api
}

module "nsg_service" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.2.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name}-service" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  security_rules            = local.config.nsg_service
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation1" {

  count = lookup(module.virtual_subnet1, "AppSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["AppSubnet"].resource.id
  network_security_group_id = module.nsg_app.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_app
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation2" {

  count = lookup(module.virtual_subnet1, "SystemNodePoolSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["SystemNodePoolSubnet"].resource.id
  network_security_group_id = module.nsg_systemnodepoolsubnet.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_systemnodepoolsubnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation3" {

  count = lookup(module.virtual_subnet1, "UserNodePoolSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["UserNodePoolSubnet"].resource.id
  network_security_group_id = module.nsg_usernodepoolsubnet.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_usernodepoolsubnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation4" {

  count = lookup(module.virtual_subnet1, "DbSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["DbSubnet"].resource.id
  network_security_group_id = module.nsg_db.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_db
  ]
}


resource "azurerm_subnet_network_security_group_association" "nsgassociation5" {

  count = lookup(module.virtual_subnet1, "ApiSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["ApiSubnet"].resource.id
  network_security_group_id = module.nsg_api.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_api
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation6" {

  count = lookup(module.virtual_subnet1, "ServiceSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1["ServiceSubnet"].resource.id
  network_security_group_id = module.nsg_service.resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg_service
  ]
}