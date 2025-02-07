module "keyvault" {
  source                        = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.5.2" 
  # version                       = "0.9.1" # this version not working for now - does not support Terraform version 1.7.5

  name                          = "${module.naming.key_vault.name_unique}${random_string.this.result}" 
  enable_telemetry              = var.enable_telemetry
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name           = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled      = false # var.purge_protection_enabled
  soft_delete_retention_days    = 7 # var.soft_delete_retention_days
  public_network_access_enabled = false
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.resource.id] 
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ServiceSubnet"].resource.id : var.subnet_id  
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "key vault" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  
  depends_on = [module.private_dns_zones]  
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.vaultcore.azure.net"

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "key vault private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = {
          env = try(local.global_settings.environment, var.environment) 
        }
      }
    }
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = module.keyvault.resource.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = ["Get"]
  secret_permissions = ["Get"]
}

