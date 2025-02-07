locals {
  endpoints = toset(["blob"])  
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.blob.core.windows.net"
  # number_of_record_sets = 2

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "storage account private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  ) 

  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id   
        autoregistration = false # true

        tags        = merge(
          local.global_settings.tags,
          {
            purpose = "storage account vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "db"   
          }
        ) 


      }
    }
}  

resource "azurerm_user_assigned_identity" "this_identity" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

data "azurerm_role_definition" "this" {
  name = "Contributor"
}

#create azure storage account
module "storageaccount" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.1.3"

  account_replication_type      = "LRS" # "GRS"
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  # name                          = "${module.naming.storage_account.name_unique}${random_string.this.result}"
  name                          = replace(replace("${module.naming.storage_account.name_unique}${random_string.this.result}", "-", ""), "_", "")
  resource_group_name           = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  min_tls_version               = "TLS1_2"
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = [azurerm_user_assigned_identity.this_identity.id]
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "storage account" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  )    
  /*lock = {
    name = "lock"
    kind = "None"
  } */
  role_assignments = {
    role_assignment_1 = {
      role_definition_id_or_name       = "Contributor" 
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },
    role_assignment_2 = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },

  }

  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    #ip_rules                   = [try(module.public_ip[0].public_ip, var.bypass_ip_cidr)]
    #virtual_network_subnet_ids = toset([azurerm_subnet.private.id])
  }

  private_endpoints = {
    for endpoint in local.endpoints :
    endpoint => {
      # the name must be set to avoid conflicting resources.
      name                          = "pe-${endpoint}-${module.naming.storage_account.name_unique}"
      # subnet_resource_id            = azurerm_subnet.private.id
      # subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["DbSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["DbSubnet"].resource.id : var.subnet_id  
      # subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.subnet_id  
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id  
      subresource_name              = endpoint
      # private_dns_zone_resource_ids = [azurerm_private_dns_zone.this[endpoint].id]
      private_dns_zone_resource_ids = [module.private_dns_zones.resource.id] 
      # these are optional but illustrate making well-aligned service connection & NIC names.
      private_service_connection_name = "psc-${endpoint}-${module.naming.storage_account.name_unique}"
      network_interface_name          = "nic-pe-${endpoint}-${module.naming.storage_account.name_unique}"
      inherit_lock                    = false

      tags        = merge(
        local.global_settings.tags,
        {
          purpose = "storage account private endpoint" 
          project_code = try(local.global_settings.prefix, var.prefix) 
          env = try(local.global_settings.environment, var.environment) 
          zone = "project"
          tier = "db"   
        }
      ) 

      role_assignments = {
        role_assignment_1 = {
          role_definition_id_or_name = "Contributor" 
          principal_id               = data.azurerm_client_config.current.object_id 
        }
      }
    }
  }

  depends_on = [
    module.private_dns_zones,
  ]
}

