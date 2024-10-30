
module "stream_analytics" {
  source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/stream-analytics"
  # source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/stream-analyticss" 

  # name                         = "${module.naming.iothub.name_unique}${random_string.this.result}"
  name                     = "${module.naming.stream_analytics_job.name}-iot"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location

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
