module "container_group1" {
  source  = "./../../../../../../modules/compute/terraform-azurerm-containergroup"

  name                = "${module.naming.container_group.name}${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name 
  location            = azurerm_resource_group.this.location 
  ip_address_type     = "Private" # "Public"
  os_type             = "Linux"
  dns_name_label      = null #  this one needs to be unique
  subnet_ids          = [local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["CiSubnet"].id ]
  restart_policy     = "OnFailure" // Possible values are 'Always'(default) 'Never' 'OnFailure'

  identity = {
    type = "SystemAssigned"
  } 

  containers = {
    nginx = { # container.key
      image  = "nginx:latest"
      cpu    = 1
      memory = 2
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
  tags = { 
    purpose = "devops runner container instance" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "devops"
    tier = "na"          
  }   
}
