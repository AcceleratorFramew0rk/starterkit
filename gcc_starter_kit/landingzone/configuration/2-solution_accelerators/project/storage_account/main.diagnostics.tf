module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-storageaccount"
  target_resource_id = module.storageaccount.resource.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["DiagnosticErrorLogs", true, false, 7],          
      #   ["OperationalLogs", true, false, 7],          
      #   ["VNetAndIPFilteringLogs", true, false, 7],          
      #   ["RuntimeAuditLogs", true, false, 7],          
      #   ["ApplicationMetricsLogs", true, false, 7], 
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        # ["AllMetrics", true, false, 7],
        ["Transaction", true, false, 0],
        ["Capacity", true, false, 0],        
      ]
    }
  }
}
