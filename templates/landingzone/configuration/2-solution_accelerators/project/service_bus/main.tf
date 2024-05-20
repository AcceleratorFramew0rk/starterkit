# add your solution accelerator terraform here.
# terraform {
#   required_version = "~> 1.5"

#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.71"
#     }

#     random = {
#       source  = "hashicorp/random"
#       version = "~> 3.6"
#     }
#   }
# }

# provider "azurerm" {
#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#   }
# }

# data "azurerm_client_config" "current" {}

# locals {
#   prefix = "pe"
# }

# module "regions" {
#   source  = "Azure/regions/azurerm"
#   version = ">= 0.3.0"

#   recommended_regions_only = true
# }

# resource "random_integer" "region_index" {
#   max = length(module.regions.regions) - 1
#   min = 0
# }

# module "naming" {
#   source  = "Azure/naming/azurerm"
#   version = ">= 0.3.0"
# }

# resource "azurerm_resource_group" "example" {
#   name     = "${module.naming.resource_group.name_unique}-${local.prefix}"
#   location = module.regions.regions[random_integer.region_index.result].name
# }

# resource "azurerm_virtual_network" "example" {
#   name = "${module.naming.virtual_network.name_unique}-${local.prefix}"

#   address_space       = ["10.0.0.0/16"]
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
# }

# resource "azurerm_subnet" "example" {
#   name = module.naming.subnet.name_unique

#   address_prefixes     = ["10.0.0.0/24"]
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
# }

# resource "azurerm_private_dns_zone" "example" {
#   name                = "privatelink.servicebus.core.windows.net"
#   resource_group_name = azurerm_resource_group.example.name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "private_links" {
#   name = "vnet-link"

#   resource_group_name   = azurerm_resource_group.example.name
#   virtual_network_id    = azurerm_virtual_network.example.id
#   private_dns_zone_name = azurerm_private_dns_zone.example.name
# }

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.servicebus.core.windows.net"
  dns_zone_tags         = {
      environment = "dev"
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
        autoregistration = false # true
        tags = {
          "env" = "dev"
        }
      }
    }
}


resource "azurerm_application_security_group" "example" {
  name = "tf-appsecuritygroup-pe" # ${local.prefix}"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

module "servicebus" {
  # source = "../../"
  source  = "Azure/avm-res-servicebus-namespace/azurerm"
  version = "0.1.0"
  # insert the 3 required variables here

  sku                           = "Premium"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  name                          = "${module.naming.container_registry.name_unique}${random_string.this.result}" # "${module.naming.servicebus_namespace.name_unique}-${local.prefix}"
  public_network_access_enabled = false

  private_endpoints = {
    max = {
      name                        = "max"
      private_dns_zone_group_name = "max_group"
      subnet_resource_id          = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id  # azurerm_subnet.example.id

      role_assignments = {
        key = {
          role_definition_id_or_name = "Contributor"
          description                = "This is a test role assignment"
          principal_id               = data.azurerm_client_config.current.object_id
        }
      }

      lock = {
        kind = "CanNotDelete"
        name = "Testing name CanNotDelete"
      }

      tags = {
        environment = "testing"
        department  = "engineering"
      }

      application_security_group_associations = {
        asg1 = azurerm_application_security_group.example.id
      }
    }

    staticIp = {
      name                   = "staticIp"
      network_interface_name = "nic1"
      subnet_resource_id     = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id  # azurerm_subnet.example.id

      ip_configurations = {
        ipconfig1 = {
          name               = "ipconfig1"
          private_ip_address = "10.0.0.7"
        }
      }
    }

    noDnsGroup = {
      name               = "noDnsGroup"
      subnet_resource_id = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id  # azurerm_subnet.example.id
    }

    withDnsGroup = {
      name                        = "withDnsGroup"
      private_dns_zone_group_name = "withDnsGroup_group"

      subnet_resource_id            = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id  # azurerm_subnet.example.id
      private_dns_zone_resource_ids = [module.private_dns_zones.private_dnz_zone_output.id] # [azurerm_private_dns_zone.example.id]
    }
  }
}



# # below is an example of container_registry
# module "private_dns_zones" {
#   source                = "Azure/avm-res-network-privatednszone/azurerm"  

#   enable_telemetry      = true
#   resource_group_name   = azurerm_resource_group.this.name
#   domain_name           = "privatelink.azurecr.io"
#   dns_zone_tags         = {
#       env = local.global_settings.environment 
#     }
#   virtual_network_links = {
#       vnetlink1 = {
#         vnetlinkname     = "vnetlink1"
#         vnetid           = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
#         autoregistration = false # true
#         tags = {
#           env = local.global_settings.environment 
#         }
#       }
#     }
# }

# module "container_registry" {
#   source = "./../../../../../../modules/compute/terraform-azurerm-containerregistry"

#   name                         = "${module.naming.container_registry.name}${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
#   resource_group_name          = azurerm_resource_group.this.name
#   location                     = azurerm_resource_group.this.location
#   sku                          = "Premium" # ["Basic", "Standard", "Premium"]
#   admin_enabled                = true 
#   log_analytics_workspace_id   = local.remote.log_analytics_workspace.id 
#   log_analytics_retention_days = 7 
#   tags = { 
#     purpose = "container registry" 
#     project_code = local.global_settings.prefix 
#     env = local.global_settings.environment 
#     zone = "project"
#     tier = "service"           
#   }     
# }

# module "private_endpoint" {
#   source = "./../../../../../../modules/networking/terraform-azurerm-privateendpoint"
  
#   name                           = "${module.container_registry.name}PrivateEndpoint"
#   location                       = azurerm_resource_group.this.location
#   resource_group_name            = azurerm_resource_group.this.name
#   subnet_id                      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceSubnet"].id 
#   tags                           = {
#       environment = "dev"
#     }
#   private_connection_resource_id = module.container_registry.id
#   is_manual_connection           = false
#   subresource_name               = "registry"
#   private_dns_zone_group_name    = "default"
#   private_dns_zone_group_ids     = [module.private_dns_zones.private_dnz_zone_output.id] 
# }

