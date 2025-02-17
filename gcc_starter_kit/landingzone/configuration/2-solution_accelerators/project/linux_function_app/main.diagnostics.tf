# # ** IMPORTANT: diagnostics settings is at the AVM modules
module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-funcapp-asp"
  target_resource_id = azurerm_service_plan.this.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      # log = [
      #   #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["FunctionAppLogs", true, false, 7],
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}
