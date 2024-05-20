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
  # source              = "../../"
  source = "./../../../../../../modules/compute/terraform-azurerm-avm-ptn-aks-production"  

  kubernetes_version  = "1.28"
  enable_telemetry    = var.enable_telemetry # see variables.tf
  name                = module.naming.kubernetes_cluster.name_unique
  resource_group_name = azurerm_resource_group.this.name
  vnet_subnet_id      = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["SystemNodePoolSubnet"].id
  node_resource_group = "${lower(module.naming.resource_group.name)}-solution-accelerators-aks-nodes" # node_resource_group                 = var.node_resource_group
  pod_cidr            = "172.31.0.0/18"
  dns_service_ip      = "172.16.0.10" # "10.0.0.10"
  service_cidr        = "172.16.0.0/18" #"10.0.0.0/16"
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id

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
      orchestrator_version = "1.28"
      max_count            = 16
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      vnet_subnet_id       = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id
    },
    ingress = {
      name                 = "ingress"
      vm_size              = "Standard_D2d_v5"
      orchestrator_version = "1.28"
      max_count            = 4
      min_count            = 2
      os_sku               = "Ubuntu"
      mode                 = "User"
      vnet_subnet_id       = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id
    }
  }
}
