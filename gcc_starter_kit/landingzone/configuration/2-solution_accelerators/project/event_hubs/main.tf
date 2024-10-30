module "event_hubs" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/event-hubs"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/event-hubs" 

  name                         = "${module.naming.eventhub.name}-iot"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location

  namespace_name      = "iotehnamespace"
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
