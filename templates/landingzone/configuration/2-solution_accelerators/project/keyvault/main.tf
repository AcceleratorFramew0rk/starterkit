module "keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.5.2"  

  name                          = "${module.naming.key_vault.name_unique}${random_string.this.result}" 
  enable_telemetry              = var.enable_telemetry
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled      = false # var.purge_protection_enabled
  soft_delete_retention_days    = 7 # var.soft_delete_retention_days
  public_network_access_enabled = false
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.private_dnz_zone_output.id] 
      subnet_resource_id            = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ServiceSubnet"].id  
    }
  }
  tags = { 
    purpose = "key vault" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "service"           
  }   
  depends_on = [module.private_dns_zones]  
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.vaultcore.azure.net"
  dns_zone_tags         = {
    env = local.global_settings.environment 
  }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = local.remote.networking.virtual_networks.spoke_project.virtual_network.id  
        autoregistration = false # true
        tags = {
          env = local.global_settings.environment 
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

