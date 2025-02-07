module "data_explorer" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/iot/data-explorer"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/iot/data-explorer"

  name                     = "${module.naming.kusto_cluster.name}-iot-${random_string.this.result}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  sku_name                 = "Standard_D13_v2" # Standard_L8as_v3
  sku_capacity             = 4 # 2


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
