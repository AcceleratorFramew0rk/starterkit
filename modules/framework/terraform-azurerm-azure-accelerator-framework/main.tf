module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  prefix                 = ["${try(local.global_settings.prefix,"")}"] 
  unique-seed            = "random"
  unique-length          = 3
  unique-include-numbers = false  
}

# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "gcci_platform" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "0-launchpad"
    key                  = "gcci-platform.tfstate" 
  }
}

data "terraform_remote_state" "spoke_management_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-spoke-management.tfstate" 
  }
}

data "terraform_remote_state" "spoke_devops_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-spoke-devops.tfstate" 
  }
}

data "terraform_remote_state" "spoke_project_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-spoke-project.tfstate" 
  }
}

data "terraform_remote_state" "hub_internet_ingress_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-hub-internet-ingress.tfstate" 
  }
}

data "terraform_remote_state" "hub_internet_egress_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-hub-internet-egress.tfstate" 
  }
}

data "terraform_remote_state" "hub_intranet_ingress_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-hub-intranet-ingress.tfstate" 
  }
}

data "terraform_remote_state" "hub_intranet_egress_virtual_subnets" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "1-landingzones"
    key                  = "network-hub-intranet-egress.tfstate" 
  }
}

# local remote variables
locals {
  global_settings = try(data.terraform_remote_state.gcci_platform.outputs.global_settings, null)     
  # virtual network name - from gcci-platform
  # e.g. 
  # local.remote.networking.virtual_networks.spoke_project.virtual_network.id 
  # local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceSubnet"].id
  remote = {
    networking = {
      virtual_networks = {
        hub_internet_ingress = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.hub_internet_ingress, null)
          virtual_subnets = try(data.terraform_remote_state.hub_internet_ingress_virtual_subnets.outputs.virtual_subnets, null)
        }
        hub_internet_egress  = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.hub_internet_egress, null)
          virtual_subnets = try(data.terraform_remote_state.hub_internet_egress_virtual_subnets.outputs.virtual_subnets, null)
        }
        hub_intranet_ingress = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.hub_intranet_ingress, null)
          virtual_subnets = try(data.terraform_remote_state.hub_intranet_ingress_virtual_subnets.outputs.virtual_subnets, null)
        }
        hub_intranet_egress = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.hub_intranet_egress, null)
          virtual_subnets = try(data.terraform_remote_state.hub_intranet_egress_virtual_subnets.outputs.virtual_subnets, null)
        }
        spoke_project = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.spoke_project, null)
          virtual_subnets = try(data.terraform_remote_state.spoke_project_virtual_subnets.outputs.virtual_subnets, null)
        }
        spoke_management = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.spoke_management, null)
          virtual_subnets = try(data.terraform_remote_state.spoke_management_virtual_subnets.outputs.virtual_subnets, null)
        }
        spoke_devops  = {
          virtual_network = try(data.terraform_remote_state.gcci_platform.outputs.spoke_devops, null)
          virtual_subnets = try(data.terraform_remote_state.spoke_devops_virtual_subnets.outputs.virtual_subnets, null)
        } 
      }
    }
    log_analytics_workspace = {
      name = try(data.terraform_remote_state.gcci_platform.outputs.gcci_agency_workspace.name, null)
      id = try(data.terraform_remote_state.gcci_platform.outputs.gcci_agency_workspace.id, null)
    }
    resource_group = try(data.terraform_remote_state.gcci_platform.outputs.gcci_platform, null)
  }
} 

