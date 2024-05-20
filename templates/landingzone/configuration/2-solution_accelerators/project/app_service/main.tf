resource "azurerm_app_service_plan" "this" {
  name                         = module.naming.app_service_plan.name
  location                     = azurerm_resource_group.this.location
  resource_group_name          = azurerm_resource_group.this.name
  kind                         = "Linux"
  maximum_elastic_worker_count = 5 

  # For kind=Linux must be set to true and for kind=Windows must be set to false
  reserved         = true 

  sku {
    tier     = "Standard"
    size     = "S1"
  }
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  

  enable_telemetry      = true
  resource_group_name   = azurerm_resource_group.this.name
  domain_name           = "privatelink.azurewebsites.net"
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

module "private_endpoint" {
  source = "./../../../../../../modules/networking/terraform-azurerm-privateendpoint"
  
  name                           = "${module.appservice.resource.name}PrivateEndpoint"
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  subnet_id                      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["WebSubnet"].id 
  tags                           = {
      environment = "dev"
    }
  private_connection_resource_id = module.appservice.resource.id
  is_manual_connection           = false
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default" 
  private_dns_zone_group_ids     = [module.private_dns_zones.private_dnz_zone_output.id] 
}

module "appservice" {
  source = "./../../../../../../modules/webapps/terraform-azurerm-appservice"

  name                         = "${module.naming.app_service.name}${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  tags = { 
    purpose = "app service" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "project"
    tier = "service"           
  } 
  app_service_plan_id = azurerm_app_service_plan.this.id
  client_affinity_enabled = false
  client_cert_enabled = false
  enabled = true
  https_only = false

  identity = {
    type = "SystemAssigned"
  }
  # key_vault_reference_identity_id = {} 
  site_config = {
    # Free tier only supports 32-bit
    use_32_bit_worker_process = true
    # Run "az webapp list-runtimes --linux" for current supported values, but
    # always connect to the runtime with "az webapp ssh" or output the value
    # of process.version from a running app because you might not get the
    # version you expect
    linux_fx_version = "NODE:20-lts" # "NODE|12-lts"
  }
  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    "Example" = "Extend",
    "LZ"      = "CAF"
  }
}

# Tested with :  AzureRM version 2.55.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config" {
  app_service_id = module.appservice.resource.id
  subnet_id      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["AppSubnet"].id 
}


