module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  count = var.appservice_web_enabled ? 1 : 0

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-appserviceweb"
  target_resource_id = module.appservice.0.resource.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AppServiceHTTPLogs", true, false, 7],
        ["AppServiceConsoleLogs", true, false, 0],
        ["AppServiceAppLogs", true, false, 7],
        ["AppServiceAuditLogs", true, false, 0],
        ["AppServiceIPSecAuditLogs", true, false, 7],
        ["AppServicePlatformLogs", true, false, 0],
        ["AppServiceAuthenticationLogs", true, false, 7],                                                 
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}

module "diagnosticsetting2" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  count = var.appservice_api_enabled ? 1 : 0

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-appserviceapi"
  target_resource_id = module.appservice1.0.resource.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AppServiceHTTPLogs", true, false, 7],
        ["AppServiceConsoleLogs", true, false, 0],
        ["AppServiceAppLogs", true, false, 7],
        ["AppServiceAuditLogs", true, false, 0],
        ["AppServiceIPSecAuditLogs", true, false, 7],
        ["AppServicePlatformLogs", true, false, 0],
        ["AppServiceAuthenticationLogs", true, false, 7],                                                 
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}

module "diagnosticsetting_appserviceplan" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-appserviceplan"
  target_resource_id = azurerm_app_service_plan.this.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      # log = [
      #   # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #   ["AppServiceHTTPLogs", true, false, 7],
      #   ["AppServiceConsoleLogs", true, false, 0],
      #   ["AppServiceAppLogs", true, false, 7],
      #   ["AppServiceAuditLogs", true, false, 0],
      #   ["AppServiceIPSecAuditLogs", true, false, 7],
      #   ["AppServicePlatformLogs", true, false, 0],
      #   ["AppServiceAuthenticationLogs", true, false, 7],                                                 
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}
