# Using the AVM module for virtual network
module "virtualnetwork_hub_internet_ingress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.ingress_egress_vnet_name_ingress_internet 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_ingress_internet_cidr}"]
  subnets = {}  
}

module "virtualnetwork_hub_internet_egress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.ingress_egress_vnet_name_egress_internet # "vnet-hub-internet"
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_egress_internet_cidr}"]
  subnets = {}   
}

module "virtualnetwork_hub_intranet_ingress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.ingress_egress_vnet_name_ingress_intranet # "vnet-hub-internet"
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_ingress_intranet_cidr}"]
  subnets = {}   
}

module "virtualnetwork_hub_intranet_egress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.ingress_egress_vnet_name_egress_intranet 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_egress_intranet_cidr}"]
  subnets = {}   
}

module "virtualnetwork_project" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.project_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.project_vnet_name_cidr}"]
  subnets = {}   
}

module "virtualnetwork_management" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.management_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.management_vnet_name_cidr}"]
  subnets = {}   
}

module "virtualnetwork_devops" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.3"

  vnet_name                     = local.devops_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  vnet_location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.devops_vnet_name_cidr}"]
  subnets = {}   
}
