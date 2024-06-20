resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = "uami-${lower(module.naming.kubernetes_cluster.name)}" # "uami-${var.kubernetes_cluster_name}"
  resource_group_name = azurerm_resource_group.this.name
}

# assign network contributor to gcci_platform resoruce group
resource "azurerm_role_assignment" "network_contributor_assignment" {
  scope                = local.remote.resource_group.id # gcci-platform resource group id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id  
  skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

# # assign reader to gcci_platform resoruce group
resource "azurerm_role_assignment" "reader_assignment" {
  scope                = local.remote.resource_group.id # gcci-platform resource group id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id 
  skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "aks_cluster" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/compute/terraform-azurerm-avm-ptn-aks-production"  
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/compute/terraform-azurerm-avm-ptn-aks-production" 

  kubernetes_version  = "1.29"
  enable_telemetry    = var.enable_telemetry # see variables.tf
  name                = module.naming.kubernetes_cluster.name_unique
  resource_group_name = azurerm_resource_group.this.name
  vnet_subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["SystemNodePoolSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["SystemNodePoolSubnet"].id : var.systemnode_subnet_id
  node_resource_group = "${lower(module.naming.resource_group.name)}-solution-accelerators-aks-nodes" # node_resource_group                 = var.node_resource_group
  pod_cidr            = "172.31.0.0/18"
  dns_service_ip      = "172.16.0.10" # "10.0.0.10"
  service_cidr        = "172.16.0.0/18" #"10.0.0.0/16"
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id

  managed_identities = {
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }

  location = azurerm_resource_group.this.location # "East US 2" # Hardcoded because we have to test in a region with availability zones
  node_pools = {
    workload = {
      name                 = "workload"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.29"
      max_count            = 4 # 16 - ensure subnet has sufficent IPs
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id : var.usernode_subnet_id
    },
    # # optional: windows node pool - uncomment if your user worker node is using os_sku = windows
    #
    # ERROR Encounter:
    # │ Agent Pool Name: "npworkload12"): performing CreateOrUpdate: unexpected status 400 (400 Bad Request) with response: {
    # │   "code": "InvalidOSSKU",
    # │   "details": null,
    # │   "message": "OSSKU='Windows2022' is invalid, details: Unrecognized OSSKU",
    # │   "subcode": "InvalidOSSKU"
    # │  }
    #
    # workload_windows = {
    #   name                 = "workload1"
    #   vm_size              = "Standard_D4s_v3"
    #   orchestrator_version = "1.29"
    #   max_count            = 4 # 16 - ensure subnet has sufficent IPs
    #   min_count            = 2
    #   os_sku               = "Windows2022" # expected os_sku to be one of ["AzureLinux" "CBLMariner" "Mariner" "Ubuntu" "Windows2019" "Windows2022"]
    #   mode                 = "User"
    #   vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolWindowsSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolWindowsSubnet"].id : var.usernodewindows_subnet_id
    # },    
    ingress = {
      name                 = "ingress"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.29"
      max_count            = 4  # 16 - ensure subnet has sufficent IPs
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id : var.usernode_subnet_id
    }
  }

  tags                = merge(
    local.global_settings.tags,
    {
      purpose = "aks private cluster" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

}
