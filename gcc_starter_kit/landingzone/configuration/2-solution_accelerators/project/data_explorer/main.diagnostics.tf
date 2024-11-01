module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-dataexplorer"
  target_resource_id = module.data_explorer.resource.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["SucceededIngestion", true, false, 7],
        ["FailedIngestion", true, false, 7],
        ["IngestionBatching", true, false, 7],
        ["Query", true, false, 7],
        ["TableUsageStatistics", true, false, 7],
        ["TableDetails", true, false, 7],
        ["Journal", true, false, 7],
        ["DataOperation", true, false, 7],
      ]
      metric = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}
