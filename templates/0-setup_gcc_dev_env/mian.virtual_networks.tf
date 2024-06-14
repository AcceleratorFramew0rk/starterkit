# Using the AVM module for virtual network
module "virtualnetwork_hub_internet_ingress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.ingress_egress_vnet_name_ingress_internet, null) == null ? 0 : 1

  name                     = local.ingress_egress_vnet_name_ingress_internet 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_ingress_internet_cidr}"]
  subnets = {}  
  tags                           = merge(
    var.tags,
    {
      purpose = "virtual network hub internet ingress" 
    }
  ) 

}

module "virtualnetwork_hub_internet_egress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.ingress_egress_vnet_name_egress_internet, null) == null ? 0 : 1

  name                     = local.ingress_egress_vnet_name_egress_internet # "vnet-hub-internet"
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_egress_internet_cidr}"]
  subnets = {}     
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_hub_internet_egress" 
    }
  ) 
}

module "virtualnetwork_hub_intranet_ingress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.ingress_egress_vnet_name_ingress_intranet, null) == null ? 0 : 1

  name                     = local.ingress_egress_vnet_name_ingress_intranet # "vnet-hub-internet"
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_ingress_intranet_cidr}"]
  subnets = {}       
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_hub_intranet_ingress" 
    }
  ) 
}

module "virtualnetwork_hub_intranet_egress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.ingress_egress_vnet_name_egress_intranet, null) == null ? 0 : 1

  name                     = local.ingress_egress_vnet_name_egress_intranet 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.ingress_egress_vnet_name_egress_intranet_cidr}"]
  subnets = {}         
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_hub_intranet_egress" 
    }
  ) 
}

module "virtualnetwork_project" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.project_vnet_name, null) == null ? 0 : 1

  name                     = local.project_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.project_vnet_name_cidr}"]
  subnets = {}         
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_project" 
    }
  ) 
}

module "virtualnetwork_management" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.management_vnet_name, null) == null ? 0 : 1

  name                     = local.management_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.management_vnet_name_cidr}"]
  subnets = {}         
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_management" 
    }
  ) 
}

module "virtualnetwork_devops" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"

  count = try(local.devops_vnet_name, null) == null ? 0 : 1

  name                     = local.devops_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  virtual_network_address_space = ["${local.devops_vnet_name_cidr}"]
  subnets = {}         
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_devops" 
    }
  ) 
}
