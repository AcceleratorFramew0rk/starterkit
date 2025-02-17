resource "azurerm_container_app_environment" "this" {
  location                 = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                     = "${module.naming.container_app_environment.name_unique}${random_string.this.result}" # "my-environment"
  resource_group_name      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  infrastructure_subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id  # azurerm_subnet.subnet.id
  internal_load_balancer_enabled = true
  logs_destination           = "log-analytics"
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id 
  
  workload_profile {
    name = (
      length(replace("${module.naming.container_app_environment.name}-${random_string.this.result}", "-", "")) > 16
      ? substr(replace("${module.naming.container_app_environment.name}-${random_string.this.result}", "-", ""), 0, 16)
      : replace("${module.naming.container_app_environment.name}-${random_string.this.result}", "-", "")
    )
    
    # ** IMPORTANT ** workload_profile_type = "D16" # Possible values include Consumption, D4, D8, D16, D32, E4, E8, E16 and E32
    workload_profile_type = var.workload_profile_type # "D16" # Possible values include Consumption, D4, D8, D16, D32, E4, E8, E16 and E32


    maximum_count = 3 # - (Required) The maximum number of instances of workload profile that can be deployed in the Container App Environment.
    minimum_count = 1 # - (Required) The minimum number of instances of workload profile that can be deployed in the Container App Environment.

  }

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "container app environment" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
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
  tags = merge(
    local.global_settings.tags,
    {
      purpose = "container app environment private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
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
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_subnet_name].resource.id : var.ingress_subnet_id 
  tags = merge(
    local.global_settings.tags,
    {
      purpose = "container app environment private endpoint" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  private_connection_resource_id = azurerm_container_app_environment.this.id
  is_manual_connection           = false
  subresource_name               = "managedEnvironments" 
  private_dns_zone_group_name    = "default" 
  private_dns_zone_group_ids     = [module.private_dns_zones[0].resource.id] 
}

module "containerapp" {
  source  = "Azure/avm-res-app-containerapp/azurerm"
  version = "0.3.0"

  for_each                     = toset(var.resource_names)
  
  container_app_environment_resource_id = azurerm_container_app_environment.this.id
  name                                  = "${module.naming.container_app.name}-${each.value}-${random_string.this.result}1" # local.counting_app_name
  resource_group_name                   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  revision_mode                         = "Single"
  template = {
    containers = [
      {
        name   = "${each.value}${random_string.this.result}" # "frontend"
        memory = var.memory # "0.5Gi"
        cpu    = var.cpu # 0.25
        image  = var.frontend_image # "docker.io/hashicorp/counting-service:0.0.2"
        # env = [
        #   {
        #     name  = "PORT"
        #     value = "900${each.value}"
        #   }
        # ]
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

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "container app - ${each.value}" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

}
