# **IMPORTANT - The environment network configuration is invalid: Provided subnet must have a size of at least /23
resource "azurerm_container_app_environment" "this" {
  location                 = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                     = "${module.naming.container_app_environment.name_unique}${random_string.this.result}" # "my-environment"
  resource_group_name      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  infrastructure_subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ContainerAppSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ContainerAppSubnet"].resource.id : var.subnet_id  # azurerm_subnet.subnet.id
  internal_load_balancer_enabled = true
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id 

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
