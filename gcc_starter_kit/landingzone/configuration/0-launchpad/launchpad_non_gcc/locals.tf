# This allow use to randomize the name of resources
locals {
  const_yaml = "yaml"
  const_yml  = "yml"
  configuration_file_path = ""
  location = "southeastasia"

  config_file_name      = local.configuration_file_path == "" ? "config.yaml" : basename(local.configuration_file_path)
  config_file_split     = split(".", local.config_file_name)
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
}
locals {
  config_template_file_variables = {
    default_location                = local.location # var.default_location
  }

  config = (local.config_file_extension == local.const_yaml ?
    yamldecode(templatefile("./../scripts/${local.config_file_name}", local.config_template_file_variables)) :
    jsondecode(templatefile("./../scripts/${local.config_file_name}", local.config_template_file_variables))
  )
}

resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

# local variables
locals {

  # GCC 2.0 compartment information 
  resource_group_name = try(local.config.resource_group_name, null) != null ? local.config.resource_group_name : var.resource_group_name # "gcci-platform"  # DO NOT CHANGE
  log_analytics_workspace_resource_group_name = try(local.config.log_analytics_workspace_resource_group_name, null) != null ? local.config.log_analytics_workspace_resource_group_name : var.log_analytics_workspace_resource_group_name # "gcci-agency-law"  # DO NOT CHANGE
  log_analytics_workspace_name = try(local.config.log_analytics_workspace_name, null) != null ? local.config.log_analytics_workspace_name : var.log_analytics_workspace_name # "gcci-agency-workspace"  # DO NOT CHANGE
  # virtual network - leave empty if there is no such virtual network   
  hub_ingress_internet_vnet_name = try(var.vnets_hub_ingress_internet_name, null) == null ? local.config.vnets.hub_ingress_internet.name : var.vnets_hub_ingress_internet_name # "gcci-vnet-ingress-internet"   # DO NOT CHANGE
  hub_egress_internet_vnet_name = try(var.vnets_hub_egress_internet_name, null) == null ? local.config.vnets.hub_egress_internet.name : var.vnets_hub_egress_internet_name # "gcci-vnet-egress-internet"  # DO NOT CHANGE
  hub_ingress_intranet_vnet_name = try(var.vnets_hub_ingress_intranet_name, null) == null ? local.config.vnets.hub_ingress_intranet.name : var.vnets_hub_ingress_intranet_name # "gcci-vnet-ingress-intranet" # empty - gcci-vnet-ingress-intranet  # DO NOT CHANGE
  hub_egress_intranet_vnet_name = try(var.vnets_hub_egress_intranet_name, null) == null ? local.config.vnets.hub_egress_intranet.name : var.vnets_hub_egress_intranet_name # "gcci-vnet-egress-intranet"  # empty - gcci-vnet-egress-intranet  # DO NOT CHANGE
  project_vnet_name = try(var.vnets_project_name, null) == null ? local.config.vnets.project.name : var.vnets_project_name # "gcci-vnet-project"   # DO NOT CHANGE
  management_vnet_name = try(var.vnets_management_name, null) == null ? local.config.vnets.management.name : var.vnets_management_name # "gcci-vnet-management"   # DO NOT CHANGE
  devops_vnet_name = try(var.vnets_devops_name, null) == null ? local.config.vnets.devops.name : var.vnets_devops_name  # "gcci-vnet-devops"   # DO NOT CHANGE
  hub_ingress_internet_vnet_name_cidr = try(var.vnets_hub_ingress_internet_cidr, null) == null ? local.config.vnets.hub_ingress_internet.cidr : var.vnets_hub_ingress_internet_cidr  # "100.127.0.0/24" # 100.1.0.0/24
  hub_egress_internet_vnet_name_cidr = try(var.vnets_hub_egress_internet_cidr, null) == null ? local.config.vnets.hub_egress_internet.cidr : var.vnets_hub_egress_internet_cidr # "100.127.1.0/24" # 100.1.1.0/24
  hub_ingress_intranet_vnet_name_cidr = try(var.vnets_hub_ingress_intranet_cidr, null) == null ? local.config.vnets.hub_ingress_intranet.cidr : var.vnets_hub_ingress_intranet_cidr # "10.20.0.0/25" # 10.2.0.0/25
  hub_egress_intranet_vnet_name_cidr = try(var.vnets_hub_egress_intranet_cidr, null) == null ? local.config.vnets.hub_egress_intranet.cidr : var.vnets_hub_egress_intranet_cidr # "10.20.1.0/25" # 10.2.1.0/25
  project_vnet_name_cidr = try(var.vnets_project_cidr, null) == null ? local.config.vnets.project.cidr : var.vnets_project_cidr # "100.64.0.0/23" # 100.64.0.0/23
  management_vnet_name_cidr = try(var.vnets_management_cidr, null) == null ? local.config.vnets.management.cidr : var.vnets_management_cidr   # "100.127.3.0/24" # 100.127.3.0/24
  devops_vnet_name_cidr = try(var.vnets_devops_cidr, null) == null ? local.config.vnets.devops.cidr : var.vnets_devops_cidr   # "100.127.4.0/24" # 100.127.4.0/24

  global_settings = {
    location = local.config.location 
    default_region = "region1"
    environment = local.config.environment 
    inherit_tags = true
    passthrough = false
    prefix = local.config.prefix 
    is_prefix = try(local.config.is_prefix, var.is_prefix) 
    prefix_with_hyphen = local.config.prefix 
    prefixes = [
      local.config.prefix 
    ]
    random_length = "3" # "${var.random_length}"
    regions = {
      region1 = local.config.location  
      region2 = "eastus"
    }
    tags  = var.global_tags
    use_slug = true
    # subnets cidr
    subnets = local.config.subnets
    vnets = local.config.vnets
    app_config = local.config.app_config
    resource_group_name = try(local.config.is_single_resource_group, false) ? local.config.resource_group_name : null
    is_single_resource_group = try(local.config.is_single_resource_group, false)
    config = local.config
  }
}  

