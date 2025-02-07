module "public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  name                = module.naming.public_ip.name_unique
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
  sku = "Standard"
}


# module "azure_bastion" {
#   source = "../../"

#   enable_telemetry    = true
#   name                = module.naming.bastion_host.name_unique
#   resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
#   location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
#   copy_paste_enabled  = true
#   file_copy_enabled   = false
#   sku                 = "Standard"
#   ip_configuration = {
#     name                 = "my-ipconfig"
#     subnet_id            = module.virtualnetwork.subnets["AzureBastionSubnet"].resource_id
#     public_ip_address_id = azurerm_public_ip.example.id
#   }
#   ip_connect_enabled     = true
#   scale_units            = 4
#   shareable_link_enabled = true
#   tunneling_enabled      = true
#   kerberos_enabled       = true

#   tags = {
#     environment = "production"
#   }
# }

# locals {
#   tags = {
#     scenario = "windows_w_data_disk_and_public_ip"
#   }
#   regions = ["southeastasia", "southeastasia"]

#   source_image_reference = {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2022-datacenter-g2"
#     version   = "latest"
#   }
# }


module "azure_bastion" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.2.0"

  // Pass in the required variables from the module
  enable_telemetry     = true
  resource_group_name  = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location             = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location  
  # virtual_network_name = try(local.remote.networking.virtual_networks.spoke_management.virtual_network.name, null) != null ? local.remote.networking.virtual_networks.spoke_management.virtual_network.name : var.vnet_name  

  // Define the bastion host configuration
  name                = "${module.naming.bastion_host.name}${random_string.this.result}" 
  copy_paste_enabled  = true
  file_copy_enabled   = false
  sku                 = "Standard" # "Premium" # for session recording preview
  ip_configuration    = {
      name                 = "${module.naming.bastion_host.name}ipconfig" # "bhipconfig" 
      subnet_id            = try(local.remote.networking.virtual_networks.spoke_management.virtual_subnets["AzureBastionSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_management.virtual_subnets["AzureBastionSubnet"].resource.id : var.subnet_id 
      public_ip_address_id = module.public_ip.public_ip_id # azurerm_public_ip.example.id
  }
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "bastion host" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "management"
      tier = "bastion"   
    }
  ) 

  # lock = {
  #   name = "my-lock"
  #   kind = "ReadOnly"
  # }

  diagnostic_settings = {
    diag_setting_1 = {
      name                                     = "${module.naming.monitor_diagnostic_setting.name_unique}-bastion"
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id 

      # storage_account_resource_id              = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{storageAccountName}"
      # event_hub_authorization_rule_resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationrules/{authorizationRuleName}"
      # event_hub_name                           = "{eventHubName}"
      # marketplace_partner_resource_id          = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{partnerResourceProvider}/{partnerResourceType}/{partnerResourceName}"
    }
  }

}






