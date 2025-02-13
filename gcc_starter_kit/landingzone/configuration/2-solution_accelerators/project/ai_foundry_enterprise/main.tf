resource "random_id" "short_name" {
  byte_length = 4
}

module "ai_foundry_enterprise" {
  source = "./../../../../../../modules/terraform-azurerm-aaf/modules/aoai/terraform-azurerm-avm-ptn-ai-foundry-enterprise"

  base_name               = local.base_name
  location                = local.location
  tags                    = local.tags
  development_environment = local.development_environment

  // use this collection to define the role templates for the different groups
  role_templates = {
    infra_admin = [
      { role_name = "contributor", scope = "resource_group_id" },
      { role_name = "azure_ai_administrator", scope = "resource_group_id" },
      { role_name = "search_index_data_contributor", scope = "ai_search_service_id" },
      { role_name = "cognitive_services_openai_user", scope = "openai_embedding_id" },
      { role_name = "cognitive_services_openai_contributor", scope = "openai_chat_id" },
      { role_name = "search_service_contributor", scope = "ai_search_service_id" },
      { role_name = "storage_blob_data_contributor", scope = "storage_account_id" },
      { role_name = "storage_file_data_privileged_contributor", scope = "storage_account_id" }
    ]
    ai_admin = [
      { role_name = "owner", scope = "ai_hub_id" },
      { role_name = "azure_ai_administrator", scope = "resource_group_id" },
      { role_name = "search_index_data_contributor", scope = "ai_search_service_id" },
      { role_name = "search_service_contributor", scope = "ai_search_service_id" },
      { role_name = "cognitive_services_openai_contributor", scope = "openai_chat_id" },
      { role_name = "cognitive_services_openai_user", scope = "openai_embedding_id" },
      { role_name = "storage_blob_data_contributor", scope = "storage_account_id" },
      { role_name = "storage_file_data_privileged_contributor", scope = "storage_account_id" }
    ]
  }

  // Use this collection to assign users to each one of the roles defined in the role_templates collection
  group_assignments = {
    infra_admin = [
      { type = "user", objectid = "a1234567-89ab-cdef-0123-456789abcdef", name = "Admin User" }
    ]
  }

  // Use this configuration to define which layer to deploy, you can also choose to deploy only an specific layer
  // Be aware that the layers are dependent on each other, so if you choose to deploy only one layer, 
  // you will need to provide the required information for the other layers
  deployment_config = {
    deploy_network  = false
    deploy_services = true
    deploy_core     = true
    deploy_identity = true
    deploy_shared   = true
  }

  // you can add extra shared private links to the shared resources module
  extra_shared_private_links = []
  // you can add extra outbound rules to the ai hub module
  extra_ai_hub_outbound_rules = {}
  // this is the configureation for the core, search and ai services
  search_config    = local.search_config
  aiservice_config = local.aiservice_config
  core_config      = local.core_config
  network          = local.network

  // use existing resource group name
  use_existing_rg = true
  existing_rg_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.id # try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name

  // use existing vnet and subnet id
  existing_vnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
  existing_subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["var.subnet_name"].resource.id : var.subnet_id

  # subscription_id = "0b5b13b8-0ad7-4552-936f-8fae87e0633f"
}