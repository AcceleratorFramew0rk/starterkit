resource "azurerm_user_assigned_identity" "this" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = "uami-${lower(module.naming.kubernetes_cluster.name)}" # "uami-${var.kubernetes_cluster_name}"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

# assign network contributor to gcci_platform resoruce group
resource "azurerm_role_assignment" "network_contributor_assignment" {
  # scope                = local.remote.resource_group.id # gcci-platform resource group id
  scope                = local.remote.networking.virtual_networks.spoke_project.virtual_network.id # project vnet id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id  
  skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

# # assign reader to gcci_platform resoruce group
resource "azurerm_role_assignment" "reader_assignment" {
  # scope                = local.remote.resource_group.id # gcci-platform resource group id
  scope                = local.remote.networking.virtual_networks.spoke_project.virtual_network.id # project vnet id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id 
  skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

# # # assign current user id to project vnet id
# resource "azurerm_role_assignment" "network_contributor_assignment1" {
#   scope                = local.remote.networking.virtual_networks.spoke_project.virtual_network.id # project vnet id
#   role_definition_name = "Network Contributor"
#   principal_id         = data.azurerm_client_config.current.object_id # principal_id 
#   # skip_service_principal_aad_check = true

#   depends_on = [
#     module.aks_cluster
#   ]
# }

# resource "azurerm_role_assignment" "reader_assignment1" {
#   scope                = local.remote.networking.virtual_networks.spoke_project.virtual_network.id # project vnet id
#   role_definition_name = "Reader"
#   principal_id         = data.azurerm_client_config.current.object_id # principal_id  
#   # skip_service_principal_aad_check = true

#   depends_on = [
#     module.aks_cluster
#   ]
# }


# Azure Kubernetes Service Cluster Admin Role - List cluster admin credential action.
# Azure Kubernetes Service RBAC Admin - Lets you manage all resources under cluster/namespace, except update or delete 
# Azure Kubernetes Service Contributor Role - Grants access to read and write Azure Kubernetes Service clusters

resource "azurerm_role_assignment" "Azure_Kubernetes_Service_Cluster_Admin_Role" {
  scope                = module.aks_cluster.resource.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = data.azurerm_client_config.current.object_id # principal_id  
  # skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

resource "azurerm_role_assignment" "Azure_Kubernetes_Service_RBAC_Admin" {
  scope                = module.aks_cluster.resource.id
  role_definition_name = "Azure Kubernetes Service RBAC Admin"
  principal_id         = data.azurerm_client_config.current.object_id # principal_id  # data.azurerm_client_config.current.object_id
  # skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

resource "azurerm_role_assignment" "Azure_Kubernetes_Service_Contributor_Role" {
  scope                = module.aks_cluster.resource.id
  role_definition_name = "Azure Kubernetes Service Contributor Role"
  principal_id         = data.azurerm_client_config.current.object_id # principal_id  
  # skip_service_principal_aad_check = true

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
  version = "0.0.8"

  kubernetes_version  = "1.30"
  enable_telemetry    = var.enable_telemetry # see variables.tf
  name                = "${module.naming.kubernetes_cluster.name}-private-cluster"  # "private-cluster" # module.naming.kubernetes_cluster
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  vnet_subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["SystemNodePoolSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["SystemNodePoolSubnet"].resource.id : var.systemnode_subnet_id
  node_resource_group = "${lower(module.naming.resource_group.name)}-solution-accelerators-aks-nodes" # node_resource_group                 = var.node_resource_group
  pod_cidr            = "172.31.0.0/18"
  dns_service_ip      = "172.16.0.10" # "10.0.0.10"
  service_cidr        = "172.16.0.0/18" #"10.0.0.0/16"

  # custom container registry id - from local remote state
  container_registry_id = local.container_registry.id

  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id

  managed_identities = {
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }

  location = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # "East US 2" # Hardcoded because we have to test in a region with availability zones
  node_pools = {
    ezwl = {
      name                 = "ezwl" # intranet (ez) workload (wl) - the "name" must begin with a lowercase letter, contain only lowercase letters and numbers and be between 1 and 12 characters in length
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.30"
      max_count            = 8 # ensure subnet has sufficent IPs
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id : var.usernode_subnet_id
      # Setting node labels
      node_labels = {
        "environment" = "production"
        "agentnodepool"         = "poolappsinternet"
      }
    }
    izwl = {
      name                 = "izwl" # intranet (iz) workload (wl)- the "name" must begin with a lowercase letter, contain only lowercase letters and numbers and be between 1 and 12 characters in length
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.30"
      max_count            = 8 # ensure subnet has sufficent IPs
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolIntranetSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolIntranetSubnet"].resource.id : var.usernode_subnet_id
      # Setting node labels
      node_labels = {
        "environment" = "production"
        "agentnodepool"         = "poolappsintranet"
      }
    }     

    #,
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
    #   orchestrator_version = "1.30"
    #   max_count            = 4 # 16 - ensure subnet has sufficent IPs
    #   min_count            = 2
    #   os_sku               = "Windows2022" # expected os_sku to be one of ["AzureLinux" "CBLMariner" "Mariner" "Ubuntu" "Windows2019" "Windows2022"]
    #   mode                 = "User"
    #   vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolWindowsSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolWindowsSubnet"].resource.id : var.usernodewindows_subnet_id
      # # # Setting node labels - hardcoded in modules
      # node_labels = {
      #   "environment" = "production"
      #   "node-pool-type"         = "user"
      # }
    # },    
    # ingress = {
    #   name                 = "ingress"
    #   vm_size              = "Standard_D2d_v5"
    #   orchestrator_version = "1.30"
    #   max_count            = 16 # - ensure subnet has sufficent IPs
    #   min_count            = 2
    #   os_sku               = "Ubuntu"
    #   mode                 = "User"
    #   vnet_subnet_id       = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id : var.usernode_subnet_id
      # # # Setting node labels - hardcoded in modules
      # node_labels = {
      #   "environment" = "production"
      #   "node-pool-type"         = "user"
      # }
    # }
   
  }

  tags                = merge(
    local.global_settings.tags,
    {
      purpose = "aks private cluster" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "nodes"   
    }
  ) 

}
