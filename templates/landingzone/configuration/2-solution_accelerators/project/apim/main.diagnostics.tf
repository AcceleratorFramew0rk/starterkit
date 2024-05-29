module "diagnosticsetting1" {
  source = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-apim"
  target_resource_id = module.apim.resource.id
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id
  diagnostics = {
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}
