resource "random_id" "prefix" {
  byte_length = 8
}

resource "random_id" "name" {
  byte_length = 8
}

# assign network contributor to gcci_platform resoruce group
resource "azurerm_role_assignment" "network_contributor_assignment" {
  scope                = local.remote.resource_group.id # azurerm_resource_group.this.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id  # aks_identity_principal_id
  skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

# # assign reader to gcci_platform resoruce group
resource "azurerm_role_assignment" "reader_assignment" {
  scope                = local.remote.resource_group.id # azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id # module.aks_cluster.cluster_identity.id # aks_identity_principal_id
  skip_service_principal_aad_check = true

  depends_on = [
    module.aks_cluster
  ]
}

locals {
  nodes = {
    for i in range(3) : "worker${i}" => {
      name                  = substr("worker${i}${random_id.prefix.hex}", 0, 8)
      vm_size               = "Standard_F8s_v2"  # "Standard_D2s_v3"
      node_count            = 1
      vnet_subnet_id        = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id : var.usernode_subnet_id
      create_before_destroy = i % 2 == 0
    }
  }
}

resource "azurerm_user_assigned_identity" "this" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = "uami-${random_id.name.hex}"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

module "aks_cluster" {
  # source  = "Azure/aks/azurerm"
  # version = "8.0.0"  
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/compute/terraform-azurerm-aks"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/compute/terraform-azurerm-aks"

  prefix                    = try(local.global_settings.prefix, var.prefix) # random_id.name.hex
  resource_group_name       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # local.resource_group.name
  kubernetes_version        = var.kubernetes_version # "1.26" # don't specify the patch version!

  # Either disable automatic upgrades, or specify `kubernetes_version` or `orchestrator_version` only up to the minor version
  # when using `automatic_channel_upgrade=patch`. You don't need to specify `kubernetes_version` at all when using
  # `automatic_channel_upgrade=stable|rapid|node-image`, where `orchestrator_version` always must be set to `null`.
  # automatic_channel_upgrade = "stable"
  # automatic_channel_upgrade = "patch"

  node_resource_group       = "${lower(module.naming.resource_group.name)}-solution-accelerators-aks-nodes" # node_resource_group                 = var.node_resource_group

  # system node poool
  agents_availability_zones = ["1", "2"] # ["1", "2", "3"]
  agents_count              = null
  agents_max_count          = 9
  agents_max_pods           = 110
  agents_min_count          = 1 # 3 for production
  agents_pool_name          = "system" # "testnodepool"
  agents_pool_linux_os_configs = [
    {
      transparent_huge_page_enabled = "always"
      sysctl_configs = [
        {
          fs_aio_max_nr               = 65536
          fs_file_max                 = 100000
          fs_inotify_max_user_watches = 1000000
        }
      ]
    }
  ]
  agents_type          = "VirtualMachineScaleSets"
  agents_pool_max_surge = "10%" # set to 10% to avoid changes when reapply. default is 10%
  azure_policy_enabled = true
  client_id            = "" # var.client_id
  client_secret        = "" # var.client_secret
  confidential_computing = {
    sgx_quote_helper_enabled = true
  }
  # disk_encryption_set_id = azurerm_disk_encryption_set.des.id
  enable_auto_scaling    = true
  enable_host_encryption = false # true
  # green_field_application_gateway_for_ingress = {
  #   name        = "${random_id.prefix.hex}-agw"
  #   subnet_cidr = "10.52.1.0/24"
  # }
  # local_account_disabled               = true
  
  log_analytics_workspace_enabled      = true # true
  log_analytics_workspace = {
    id = local.remote.log_analytics_workspace.id
    name = local.remote.log_analytics_workspace.name
    location = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  }
  microsoft_defender_enabled = true

  # cluster_log_analytics_workspace_name = random_id.name.hex
  maintenance_window = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ]
    not_allowed = [
      {
        start = "2035-01-01T20:00:00Z",
        end   = "2035-01-01T21:00:00Z"
      },
    ]
  }
  maintenance_window_node_os = {
    frequency  = "Daily"
    interval   = 1
    start_time = "07:00"
    utc_offset = "+01:00"
    duration   = 16
  }
  net_profile_dns_service_ip        = "172.16.0.10" # "10.0.0.10"
  net_profile_service_cidr          = "172.16.0.0/18" #"10.0.0.0/16"
  net_profile_pod_cidr              = "172.31.0.0/18"  
  network_plugin_mode               = "overlay"
  network_plugin                    = "azure"
  network_policy                    = "azure"
  node_os_channel_upgrade           = "NodeImage"
  os_disk_size_gb                   = 60
  private_cluster_enabled           = true
  rbac_aad                          = false # true
  rbac_aad_managed                  = false # true
  role_based_access_control_enabled = true # true 
  oidc_issuer_enabled               = true

  identity_ids        = [azurerm_user_assigned_identity.this.id]
  identity_type       = "UserAssigned"
  # rbac_aad            = false
  # network_contributor_role_assigned_subnet_ids = {
  #   # vnet_subnet = azurerm_subnet.subnet.id
  #   vnet_subnet = local.remote.networking.virtual_networks.spoke_project.virtual_subnets["SystemNodePoolSubnet"].resource.id  # azurerm_subnet.test.id
  #   # vnet_subnet1 = = local.remote.networking.virtual_networks.spoke_project.virtual_subnets["UserNodePoolSubnet"].resource.id  # azurerm_subnet.test.id
  # }

  sku_tier                          = "Standard" # Free, Standard or Premium
  vnet_subnet_id                    = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["SystemNodePoolSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["SystemNodePoolSubnet"].resource.id : var.systemnode_subnet_id

  agents_labels = {
    "node1" : "label1"
  }
  agents_tags = {
    "Agent" : "agentTag"
  }

  # set auto_scaler_profile balance_similar_node_groups to true
  # e.g.
  # auto_scaler_profile {
  #   balance_similar_node_groups = true
  # }
  auto_scaler_profile_enabled = true
  auto_scaler_profile_balance_similar_node_groups = true


  # user node pool
  node_pools          = local.nodes

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

  depends_on = [
    module.natgateway,
    module.subnet_nat_gateway_association, 
    azurerm_user_assigned_identity.this,
    azurerm_resource_group.this
  ]
}