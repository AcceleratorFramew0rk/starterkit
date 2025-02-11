resource "azurerm_container_app_environment" "this" {
  location                 = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                     = "${module.naming.container_app_environment.name_unique}${random_string.this.result}" # "my-environment"
  resource_group_name      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  infrastructure_subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ContainerAppSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ContainerAppSubnet"].resource.id : var.subnet_id  # azurerm_subnet.subnet.id
  internal_load_balancer_enabled = true
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id 
  
  workload_profile {
    name = (
      length(replace("${module.naming.container_app_environment.name}-${random_string.this.result}", "-", "")) > 16
      ? substr(replace("${module.naming.container_app_environment.name}-${random_string.this.result}", "-", ""), 0, 16)
      : replace("${module.naming.container_app_environment.name}-${random_string.this.result}", "-", "")
    )
    workload_profile_type = "D8" # Possible values include Consumption, D4, D8, D16, D32, E4, E8, E16 and E32

    maximum_count = 10 # - (Required) The maximum number of instances of workload profile that can be deployed in the Container App Environment.
    minimum_count = 1 # - (Required) The minimum number of instances of workload profile that can be deployed in the Container App Environment.

  }

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "container app environment" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "db"   
    }
  )   
}


module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  version = "0.3.0" 

  count = var.private_dns_zones_enabled ? 1 : 0

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.azurecontainerapps.io"
  tags         = {
      environment = "dev"
    }
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = {
          "env" = "dev"
        }
      }
    }
}

module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"
 
  name                           = "${azurerm_container_app_environment.this.name}-web-privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["WebSubnet"].resource.id : var.subnet_id 
  tags                           = {
      environment = "dev"
    }
  private_connection_resource_id = azurerm_container_app_environment.this.id
  is_manual_connection           = false
  subresource_name               = "managedEnvironments" # "containerappsenvironment"
  private_dns_zone_group_name    = "default" 
  private_dns_zone_group_ids     = [module.private_dns_zones[0].resource.id] 
}

module "containerapp_frontend" {
  source  = "Azure/avm-res-app-containerapp/azurerm"
  version = "0.3.0"

  container_app_environment_resource_id = azurerm_container_app_environment.this.id
  name                                  = "${module.naming.container_app.name}-${random_string.this.result}1" # local.counting_app_name
  resource_group_name                   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  revision_mode                         = "Single"
  template = {
    containers = [
      {
        name   = "frontend${random_string.this.result}" # "frontend"
        memory = var.memory # "0.5Gi"
        cpu    = var.cpu # 0.25
        image  = var.frontend_image # "docker.io/hashicorp/counting-service:0.0.2"
        env = [
          {
            name  = "PORT"
            value = "9001"
          }
        ]
      },
    ]
  }
  ingress = {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 9001
    traffic_weight = [{
      latest_revision = true
      percentage      = 100
    }]
  }  
}

module "containerapp_backend" {
  source  = "Azure/avm-res-app-containerapp/azurerm"
  version = "0.3.0"

  container_app_environment_resource_id = azurerm_container_app_environment.this.id
  name                                  = "${module.naming.container_app.name}-${random_string.this.result}2" #   local.dashboard_app_name
  resource_group_name                   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  revision_mode                         = "Single"
  template = {
    containers = [
      {
        name   = "backend${random_string.this.result}" # "backend"
        memory = var.memory # "1Gi"
        cpu    = var.cpu # 0.5
        image  = var.backend_image # "docker.io/hashicorp/dashboard-service:0.0.4"
        env = [
          {
            name  = "PORT"
            value = "8080"
          },
          # {
          #   name  = "COUNTING_SERVICE_URL"
          #   value = "http://${local.counting_app_name}"
          # }
        ]
      },
    ]
  }

  ingress = {
    allow_insecure_connections = false
    target_port                = 8080
    external_enabled           = true

    traffic_weight = [{
      latest_revision = true
      percentage      = 100
    }]
  }
  managed_identities = {
    system_assigned = true
  }
}
