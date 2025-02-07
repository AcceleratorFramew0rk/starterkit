
locals {
  development_environment = true
  base_name               = "${random_id.short_name.hex}${random_id.short_name.dec}"
  location                = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # "swedencentral"
  tags                    = { "Environment" = "development", "Owner" = "team" }

  search_config = {
    private_dns_zone_ids       = []
    tags                       = {}
    sku_name                   = "standard"
    disable_local_auth         = true
    hosting_mode               = "default"
    public_network_access      = "disabled"
    partition_count            = 1
    replica_count              = 1
    semantic_search            = "disabled"
    search_identity_provider   = { type = "None" }
    deploy_shared_private_link = true
    deploy_private_dns_zones   = true
  }

  network = {
    base_name                       = "network-base"
    development_environment         = local.development_environment
    vnet_address_prefix             = "10.0.0.0/16"
    app_gateway_subnet_prefix       = "10.0.1.0/24"
    private_endpoints_subnet_prefix = "10.0.2.0/27"
    agents_subnet_prefix            = "10.0.2.32/27"
    bastion_subnet_prefix           = "10.0.2.64/26"
    jumpbox_subnet_prefix           = "10.0.2.128/28"
    training_subnet_prefix          = "10.0.3.0/24"
    scoring_subnet_prefix           = "10.0.4.0/24"
    app_services_subnet_prefix      = "10.0.5.0/24"
  }

  aiservice_config = {
    private_dns_zone_ids     = []
    aiServiceSkuName         = "S0"
    base_name                = local.base_name
    disableLocalAuth         = false
    deploy_private_dns_zones = true
  }

  core_config = {
    acr = {
      private_dns_zone_ids   = []
      deploy_acr_private_dns = true
    }
    storage = {
      private_dns_zone_ids       = []
      deploy_storage_private_dns = true
    }
    key_vault = {
      private_dns_zone_ids       = []
      deploy_storage_private_dns = true
    }
    ai_hub = {
      private_dns_zone_ids = []
      tags                 = local.tags
      deploy_private_dns   = true
      description          = "AI Hub"
    }
  }
}
