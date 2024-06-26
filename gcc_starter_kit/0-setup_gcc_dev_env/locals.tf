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
    yamldecode(templatefile("./${local.config_file_name}", local.config_template_file_variables)) :
    jsondecode(templatefile("./${local.config_file_name}", local.config_template_file_variables))
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
  resource_group_name = local.config.resource_group_name # 
  log_analytics_workspace_resource_group_name = local.config.log_analytics_workspace_resource_group_name # "gcci-agency-law"  # DO NOT CHANGE
  log_analytics_workspace_name = local.config.log_analytics_workspace_name # "gcci-agency-workspace"  # DO NOT CHANGE
  # virtual network - leave empty if there is no such virtual network   
  hub_ingress_internet_vnet_name = local.config.hub_ingress_internet_vnet_name # "gcci-vnet-ingress-internet"   # DO NOT CHANGE
  hub_egress_internet_vnet_name = local.config.hub_egress_internet_vnet_name # "gcci-vnet-egress-internet"  # DO NOT CHANGE
  hub_ingress_intranet_vnet_name = local.config.hub_ingress_intranet_vnet_name # "gcci-vnet-ingress-intranet" # empty - gcci-vnet-ingress-intranet  # DO NOT CHANGE
  hub_egress_intranet_vnet_name = local.config.hub_egress_intranet_vnet_name # "gcci-vnet-egress-intranet"  # empty - gcci-vnet-egress-intranet  # DO NOT CHANGE
  project_vnet_name = local.config.project_vnet_name # "gcci-vnet-project"   # DO NOT CHANGE
  management_vnet_name = local.config.management_vnet_name # "gcci-vnet-management"   # DO NOT CHANGE
  devops_vnet_name = local.config.devops_vnet_name # "gcci-vnet-devops"   # DO NOT CHANGE
  hub_ingress_internet_vnet_name_cidr = local.config.hub_ingress_internet_vnet_name_cidr # "100.127.0.0/24" # 100.1.0.0/24
  hub_egress_internet_vnet_name_cidr = local.config.hub_egress_internet_vnet_name_cidr # "100.127.1.0/24" # 100.1.1.0/24
  hub_ingress_intranet_vnet_name_cidr = local.config.hub_ingress_intranet_vnet_name_cidr # "10.20.0.0/25" # 10.2.0.0/25
  hub_egress_intranet_vnet_name_cidr = local.config.hub_egress_intranet_vnet_name_cidr # "10.20.1.0/25" # 10.2.1.0/25
  project_vnet_name_cidr = local.config.project_vnet_name_cidr # "100.64.0.0/23" # 100.64.0.0/23
  management_vnet_name_cidr = local.config.management_vnet_name_cidr # "100.127.3.0/24" # 100.127.3.0/24
  devops_vnet_name_cidr = local.config.devops_vnet_name_cidr # "100.127.4.0/24" # 100.127.4.0/24
}  

