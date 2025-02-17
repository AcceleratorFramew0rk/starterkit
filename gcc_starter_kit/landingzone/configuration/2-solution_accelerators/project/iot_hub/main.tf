module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"  
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.azure-devices.net"
  tags         = merge(
    local.global_settings.tags,
    {
      purpose = "iot hub private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  )
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = merge(
          local.global_settings.tags,
          {
            purpose = "iot hub vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "service"   
          }
        )
      }
    
    }
}

module "private_dns_zones_dps" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"    
  version = "0.1.2" 

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.provisioning.azure-devices.net"
  tags         = merge(
    local.global_settings.tags,
    {
      purpose = "iot hub dps private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  )
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = merge(
          local.global_settings.tags,
          {
            purpose = "iot hub dps vnet link" 
            project_code = try(local.global_settings.prefix, var.prefix) 
            env = try(local.global_settings.environment, var.environment) 
            zone = "project"
            tier = "service"   
          }
        )
      }
    
    }
}

module "iot_hub" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/iot-hub"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/iot-hub"

  name                         = "${module.naming.iothub.name}-iot-${random_string.this.result}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  # iot hub configuration
  sku                 = "S1"
  capacity            = 1
  # public_network_access_enabled = false

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "iot hub" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
}

# Create IoT Hub Access Policy
resource "azurerm_iothub_shared_access_policy" "this" {
  name                = "${module.naming.iothub.name}sap-${random_string.this.result}" # "terraform-policy"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  iothub_name         = module.iot_hub.resource.name # azurerm_iothub.iothub.name

  registry_read   = true
  registry_write  = true
  service_connect = true

  depends_on = [
    module.iot_hub
  ]
}



# Create IoTHub dps
resource "azurerm_iothub_dps" "this" {
  name                = "${module.naming.iothub.name}-dps-${random_string.this.result}"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  allocation_policy   = "Hashed"

  sku {
    name     = "S1"
    capacity = 1
  }
  public_network_access_enabled = false

  linked_hub {
    connection_string       = azurerm_iothub_shared_access_policy.this.primary_connection_string
    location                = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
    allocation_weight       = 150
    apply_allocation_policy = true
  }
  
  depends_on = [
    module.iot_hub, 
    azurerm_iothub_shared_access_policy.this
  ]

}

# Add a delay after IoT Hub creation
resource "time_sleep" "wait_for_iothub" {
  depends_on = [module.iot_hub]  # Ensure IoT Hub is created first
  create_duration = "60s"  # Wait 30 seconds before proceeding
}

module "private_endpoint" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

  name                           = "${module.iot_hub.name}privateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "iot hub private endpoint" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
  private_connection_resource_id = module.iot_hub.id
  is_manual_connection           = false
  subresource_name               = "iotHub" # ["iotHub"] # "registry"
  private_dns_zone_group_name    = "iothubsPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [module.private_dns_zones.resource.id] 
  
  depends_on = [
    time_sleep.wait_for_iothub,
    module.iot_hub, 
    module.private_dns_zones
  ]

}


module "private_endpoint_dps" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-privateendpoint"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-privateendpoint"

  name                           = "${module.iot_hub.name}dpsprivateendpoint"
  location                       = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  subnet_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.dps_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.dps_subnet_name].resource.id : var.dps_subnet_id 
  tags                           = merge(
    local.global_settings.tags,
    {
      purpose = "iot hub dps private endpoint" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
  private_connection_resource_id = azurerm_iothub_dps.this.id
  is_manual_connection           = false
  subresource_name               = "iotDps" # Corrected subresource for IoT DPS
  private_dns_zone_group_name    = "iotdpsPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [module.private_dns_zones_dps.resource.id] 
  
  depends_on = [
    time_sleep.wait_for_iothub,
    azurerm_iothub_dps.this, 
    module.private_dns_zones_dps
  ]

}
