# Using the AVM module for virtual network
module "virtualnetwork_hub_internet_ingress" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.2.3"

  count = try(local.hub_ingress_internet_vnet_name, null) == null ? 0 : 1

  name                     = local.hub_ingress_internet_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.hub_ingress_internet_vnet_name_cidr}"]
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
  version = "0.2.3"

  count = try(local.hub_egress_internet_vnet_name, null) == null ? 0 : 1

  name                     = local.hub_egress_internet_vnet_name # "vnet-hub-internet"
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.hub_egress_internet_vnet_name_cidr}"]
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
  version = "0.2.3"

  count = try(local.hub_ingress_intranet_vnet_name, null) == null ? 0 : 1

  name                     = local.hub_ingress_intranet_vnet_name # "vnet-hub-internet"
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.hub_ingress_intranet_vnet_name_cidr}"]
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
  version = "0.2.3"

  count = try(local.hub_egress_intranet_vnet_name, null) == null ? 0 : 1

  name                     = local.hub_egress_intranet_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.hub_egress_intranet_vnet_name_cidr}"]
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
  version = "0.2.3"

  count = try(local.project_vnet_name, null) == null ? 0 : 1

  name                     = local.project_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.project_vnet_name_cidr}"]
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
  version = "0.2.3"

  count = try(local.management_vnet_name, null) == null ? 0 : 1

  name                     = local.management_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.management_vnet_name_cidr}"]
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
  version = "0.2.3"

  count = try(local.devops_vnet_name, null) == null ? 0 : 1

  name                     = local.devops_vnet_name 
  enable_telemetry              = true
  resource_group_name           = azurerm_resource_group.this.name
  location                 = var.location # "southeastasia"
  address_space = ["${local.devops_vnet_name_cidr}"]
  subnets = {}         
  tags                           = merge(
    var.tags,
    {
      purpose = "virtualnetwork_devops" 
    }
  ) 
}
