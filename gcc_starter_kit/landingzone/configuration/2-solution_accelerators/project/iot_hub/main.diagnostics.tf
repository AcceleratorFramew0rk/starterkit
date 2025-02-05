module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-iothub"
  target_resource_id = module.iot_hub.resource.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["Connections", true, false, 7],
        ["DeviceTelemetry", true, false, 7],
        ["C2DCommands", true, false, 7],
        ["DeviceIdentityOperations", true, false, 7],
        ["FileUploadOperations", true, false, 7],
        ["Routes", true, false, 7],
        ["D2CTwinOperations", true, false, 7],
        ["C2DTwinOperations", true, false, 7],
        ["TwinQueries", true, false, 7],
        ["JobsOperations", true, false, 7],
        ["DirectMethods", true, false, 7],
        ["DistributedTracing", true, false, 7],
        ["Configurations", true, false, 7],
        ["DeviceStreams", true, false, 7],
      ]
      metric = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}

module "diagnosticsetting2" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-iothubdps"
  target_resource_id = azurerm_iothub_dps.this.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["DeviceOperations", true, false, 7],
        ["ServiceOperations", true, false, 7],
      ]
      metric = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}