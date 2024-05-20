module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.openai.azure.com"
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

resource "random_pet" "pet" {}

module "azureopenai" {
  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.1.1"  

  kind                = "OpenAI"
  location            = azurerm_resource_group.eastus.location 
  name                = "${module.naming.cognitive_account.name_unique}-${random_string.this.result}-openai"
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
      private_dns_zone_resource_ids   = [module.private_dns_zones.private_dnz_zone_output.id]  # toset([azurerm_private_dns_zone.zone.id])
      private_service_connection_name = "pe_endpoint_connection"
      subnet_resource_id              = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["AiSubnet"].id  # module.virtualnetwork_project.subnets["AiSubnet"].id # module.vnet.vnet_subnets_name_id["subnet0"]
    }
  }

  tags = { 
    purpose = "azure open ai service" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "ai"           
  }   

  depends_on = [
    module.private_dns_zones
  ]
}
