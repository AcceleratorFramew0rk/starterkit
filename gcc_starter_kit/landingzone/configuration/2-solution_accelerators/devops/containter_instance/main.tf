module "container_group1" {
  # source  = "./../../../../../../modules/terraform-azurerm-aaf/modules/compute/terraform-azurerm-containergroup"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/compute/terraform-azurerm-containergroup"  

  name                = "${module.naming.container_group.name}-${random_string.this.result}"
  # resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name 
  # location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name

  ip_address_type     = "Private" # "Public"
  os_type             = "Linux"
  dns_name_label      = null #  this one needs to be unique
  subnet_ids          = [try(local.remote.networking.virtual_networks.spoke_devops.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_devops.virtual_subnets[var.subnet_name].resource.id : var.subnet_id]
  restart_policy     = "OnFailure" // Possible values are 'Always'(default) 'Never' 'OnFailure'

  identity = {
    type = "SystemAssigned"
  } 

  containers = {
    container1 = { # container.key
      image  = try(var.image, null) == null ? "acceleratorframew0rk/gccstarterkit-avm-sde:0.3" : var.image  
      cpu    = try(var.cpu, 1)
      memory = try(var.memory, 2)
      ports = {
        port80 = {
          port     = 80
          protocol = "TCP"
        }
        443 = {
          port     = 443
          protocol = "TCP"
        }          
        22 = {
          port     = 22
          protocol = "TCP"
        }          
      }
      volumes = {
        nginx-html = {
          mount_path = "/usr/share/nginx/html"
          secret = {
            "index.html" = base64encode("<h1>Hello World</h1>")
          }
        }
      }
      commands = ["/bin/sh", "-c", "while sleep 1000; do :; done"]
    }
  }

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
