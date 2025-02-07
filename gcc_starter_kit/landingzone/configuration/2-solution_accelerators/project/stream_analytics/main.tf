
module "stream_analytics" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/stream-analytics"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/stream-analytics"

  # name                         = "${module.naming.iothub.name_unique}${random_string.this.result}"
  name                     = "${module.naming.stream_analytics_job.name}-iot-${random_string.this.result}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  iot_hub_id = local.iothub_id 
  data_explorer_id = local.dataexplorer.resource.id
  eventhub_namespace_id = local.eventhubs.eventhub_namespace_id 
  sql_server_id = local.sqlserver.id

 
  tags = merge(
    local.global_settings.tags,
    {
      purpose = "data explorer" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "service"   
    }
  ) 
}
