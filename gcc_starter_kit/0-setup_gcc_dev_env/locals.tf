# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

# local variables
locals {
  # GCC 2.0 compartment information 
  resource_group_name = "gcci-platform" # DO NOT CHANGE
  log_analytics_workspace_resource_group_name = "gcci-agency-law"  # DO NOT CHANGE
  log_analytics_workspace_name = "gcci-agency-workspace"  # DO NOT CHANGE
  # virtual network - leave empty if there is no such virtual network   
  ingress_egress_vnet_name_ingress_internet = "gcci-vnet-ingress-internet"   # DO NOT CHANGE
  ingress_egress_vnet_name_egress_internet = "gcci-vnet-egress-internet"  # DO NOT CHANGE
  ingress_egress_vnet_name_ingress_intranet = "gcci-vnet-ingress-intranet" # empty - gcci-vnet-ingress-intranet  # DO NOT CHANGE
  ingress_egress_vnet_name_egress_intranet = "gcci-vnet-egress-intranet"  # empty - gcci-vnet-egress-intranet  # DO NOT CHANGE
  project_vnet_name = "gcci-vnet-project"   # DO NOT CHANGE
  management_vnet_name = "gcci-vnet-management"   # DO NOT CHANGE
  devops_vnet_name = "gcci-vnet-devops"   # DO NOT CHANGE
  ingress_egress_vnet_name_ingress_internet_cidr = "100.127.0.0/24" # 100.1.0.0/24
  ingress_egress_vnet_name_egress_internet_cidr = "100.127.1.0/24" # 100.1.1.0/24
  ingress_egress_vnet_name_ingress_intranet_cidr = "10.20.0.0/25" # 10.2.0.0/25
  ingress_egress_vnet_name_egress_intranet_cidr = "10.20.1.0/25" # 10.2.1.0/25
  project_vnet_name_cidr = "100.64.0.0/23" # 100.64.0.0/23
  management_vnet_name_cidr = "100.127.3.0/24" # 100.127.3.0/24
  devops_vnet_name_cidr = "100.127.4.0/24" # 100.127.4.0/24
}  