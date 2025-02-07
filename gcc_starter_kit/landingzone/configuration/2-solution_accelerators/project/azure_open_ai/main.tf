module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.openai.azure.com"

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "azure open ai service private dns zone" 
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

        tags        = merge(
          local.global_settings.tags,
          {
            purpose = "azure open ai service vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "app"   
          }
        ) 


      }
    }
}

resource "random_pet" "pet" {}

module "azureopenai" {
  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.1.1"  

  kind                = "OpenAI"
  location            = azurerm_resource_group.eastus.location 
  name                = "${module.naming.cognitive_account.name}-openai-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.eastus.name  # location east us resource group
  sku_name            = "S0"

  cognitive_deployments = {
    "gpt-4-32k" = {
      name = "gpt-4-32k"
      model = {
        format  = "OpenAI"
        name    = "gpt-4-32k"
        version = "0613"
      }
      scale = {
        type = "Standard"
      }
    }
  }
  private_endpoints = {
    pe_endpoint = {
      name                            = "pe_endpoint"
      private_dns_zone_resource_ids   = [module.private_dns_zones.resource.id]  
      private_service_connection_name = "pe_endpoint_connection"
      subnet_resource_id              = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AiSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["AiSubnet"].resource.id : var.subnet_id  
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "azure open ai service" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

  depends_on = [
    module.private_dns_zones
  ]
}
