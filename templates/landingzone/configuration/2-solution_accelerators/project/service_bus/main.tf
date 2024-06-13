# add your solution accelerator terraform here.
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
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = {
          "env" = "dev"
        }
      }
    }
}


resource "azurerm_application_security_group" "this" {
  name = "tf-appsecuritygroup-pe" 

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

module "servicebus" {
  source  = "Azure/avm-res-servicebus-namespace/azurerm"
  version = "0.1.0"

  # insert the 3 required variables here
  sku                           = "Premium"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  name                          = "${module.naming.container_registry.name_unique}${random_string.this.result}" 
  public_network_access_enabled = false

  private_endpoints = {
    max = {
      name                        = "max"
      private_dns_zone_group_name = "max_group"
      subnet_resource_id          = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id : var.subnet_id 

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
        asg1 = azurerm_application_security_group.this.id
      }
    }

    staticIp = {
      name                   = "staticIp"
      network_interface_name = "nic1"
      subnet_resource_id     = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id : var.subnet_id 

      ip_configurations = {
        ipconfig1 = {
          name               = "ipconfig1"
          private_ip_address = try(cidrhost(local.global_settings.subnets.project.ServiceBusSubnet.address_prefixes.0, 10), null)  # "100.64.1.100" 
        }
      }
    }

    noDnsGroup = {
      name               = "noDnsGroup"
      subnet_resource_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id : var.subnet_id 
    }

    withDnsGroup = {
      name                        = "withDnsGroup"
      private_dns_zone_group_name = "withDnsGroup_group"

      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceBusSubnet"].id : var.subnet_id 
      private_dns_zone_resource_ids = [module.private_dns_zones.private_dnz_zone_output.id] 
    }
  }
}

