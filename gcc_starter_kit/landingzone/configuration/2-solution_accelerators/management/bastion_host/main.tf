module "public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.public_ip.name_unique
  location            = azurerm_resource_group.this.location 
  sku = "Standard"
}

module "azure_bastion" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.1.1"

  // Pass in the required variables from the module
  enable_telemetry     = true
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = local.remote.networking.virtual_networks.spoke_management.virtual_network.name  

  // Define the bastion host configuration
  bastion_host = {
    name                = "${module.naming.bastion_host.name}${random_string.this.result}" 
    resource_group_name = azurerm_resource_group.this.name
    location            = azurerm_resource_group.this.location
    copy_paste_enabled  = true
    file_copy_enabled   = false
    sku                 = "Standard"
    ip_configuration = {
      name                 = "${module.naming.bastion_host.name}ipconfig" # "bhipconfig" 
      subnet_id            = local.remote.networking.virtual_networks.spoke_management.virtual_subnets.subnets["AzureBastionSubnet"].id  # module.virtualnetwork.subnets["AzureBastionSubnet"].id
      public_ip_address_id = module.public_ip.public_ip_id # azurerm_public_ip.example.id
    }
    ip_connect_enabled     = true
    scale_units            = 2
    shareable_link_enabled = true
    tunneling_enabled      = true
    tags = { 
      purpose = "bastion host" 
      project_code = local.global_settings.prefix 
      env = local.global_settings.environment 
      zone = "management"
      tier = "na"           
    } 

    lock = {
      name = "my-lock"
      kind = "ReadOnly"

    }
    diagnostic_settings = {
      diag_setting_1 = {
        name                                     = "diagSetting1"
        log_groups                               = ["allLogs"]
        metric_categories                        = ["AllMetrics"]
        log_analytics_destination_type           = "Dedicated"
        workspace_resource_id                    = local.remote.log_analytics_workspace.id # "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}"
        # storage_account_resource_id              = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}"
        # event_hub_authorization_rule_resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationrules/{authorizationRuleName}"
        # event_hub_name                           = "{eventHubName}"
        # marketplace_partner_resource_id          = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{partnerResourceProvider}/{partnerResourceType}/{partnerResourceName}"
      }
    }
  }
}






