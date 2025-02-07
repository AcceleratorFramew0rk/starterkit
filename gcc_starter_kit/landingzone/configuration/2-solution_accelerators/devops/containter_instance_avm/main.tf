
module "container_group1" {
  # source  = "./../../../../../../modules/terraform-azurerm-aaf/modules/compute/terraform-azurerm-avm-res-containerinstance-containergroup"
  source  = "Azure/avm-res-containerinstance-containergroup/azurerm"
  version = "0.1.0"

  name                = "${module.naming.container_group.name}-${random_string.this.result}" # module.naming.container_group.name_unique
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name
  os_type             = "Linux"
  subnet_ids          = [try(local.remote.networking.virtual_networks.spoke_devops.virtual_subnets["RunnerSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_devops.virtual_subnets["RunnerSubnet"].resource.id : var.subnet_id]
  restart_policy      = "OnFailure" // Possible values are 'Always'(default) 'Never' 'OnFailure'
  
  diagnostics_log_analytics = {
    workspace_id  = try(local.remote.log_analytics_workspace.resource.workspace_id, null) 
    workspace_key = try(local.remote.log_analytics_workspace.resource.primary_shared_key, null) 
  }

  zones            = ["1"]
  priority         = "Regular"
  enable_telemetry = var.enable_telemetry
  containers = {
    container1 = {
      name   = "container1"
      image  = try(var.image, null) == null ? "acceleratorframew0rk/gccstarterkit-avm-sde:0.3" : var.image  
      cpu    = try(var.cpu, 1)
      memory = try(var.memory, 2)
      ports = [
        {
          port     = 80
          protocol = "TCP"
        }, 
        {
          port     = 443
          protocol = "TCP"
        },
        {
          port     = 22
          protocol = "TCP"
        }                 
      ]      
      environment_variables = {
        "ENVIRONMENT" = "production"
      }
      secure_environment_variables = {
        "SECENV" = "avmpoc"
      }
      volumes = {
        secrets = {
          mount_path = "/etc/secrets"
          name       = "secret1"
          secret = {
            "password" = base64encode("password123")
          }
        },
        nginx = {
          mount_path = "/usr/share/nginx/html"
          name       = "nginx"
          secret = {
            "indexpage" = base64encode("Hello, World!")
          }
        }
      }
      commands = ["/bin/sh", "-c", "while sleep 1000; do :; done"]
    }
  }
  exposed_ports = [
    {
      port     = 80
      protocol = "TCP"
    }, 
    {
      port     = 443
      protocol = "TCP"
    },
    {
      port     = 22
      protocol = "TCP"
    }   
  ]
  managed_identities = {
    system_assigned            = true
    # user_assigned_resource_ids = [azurerm_user_assigned_identity.this.id]
  }
  # role_assignments = {
  #   role_assignment_1 = {
  #     role_definition_id_or_name       = "Contributor"
  #     principal_id                     = data.azurerm_client_config.current.object_id
  #     skip_service_principal_aad_check = false
  #   }
  # }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "devops runner container instance" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "devops"
      tier = "na"   
    }
  ) 

}

