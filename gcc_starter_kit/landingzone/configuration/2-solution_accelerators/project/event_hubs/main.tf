module "event_hubs" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/event-hubs"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/event-hubs" 

  name                         = "${module.naming.eventhub.name}-iot-${random_string.this.result}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  namespace_name      = "${module.naming.eventhub_namespace.name}-iot-${random_string.this.result}"  #  "iotehnamespace"
  partition_count     = 2 # 4
  message_retention   = 7

  tags = merge(
    local.global_settings.tags,
    {
      purpose = "event hubs" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = ""   
    }
  ) 
}
