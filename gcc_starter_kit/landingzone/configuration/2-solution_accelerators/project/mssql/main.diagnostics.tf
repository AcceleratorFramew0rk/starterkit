module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-mssql-database"
  target_resource_id = module.sql_server.resource_databases.database1.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AutomaticTuning", true, false, 7],
        ["Blocks", true, false, 7],
        ["DatabaseWaitStatistics", true, false, 7],
        ["Deadlocks", true, false, 7],
        ["DevOpsOperationsAudit", true, false, 7],
        ["QueryStoreRuntimeStatistics", true, false, 7],
        ["QueryStoreWaitStatistics", true, false, 7],
        ["SQLInsights", true, false, 7],
        ["SQLSecurityAuditEvents", true, false, 7],
        ["Timeouts", true, false, 7],
        ["Errors", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["Basic", true, false, 7],
        ["InstanceAndAppAdvanced", true, false, 7],
        ["WorkloadManagement", true, false, 7],
      ]
    }
  }
}

module "diagnosticsetting2" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-electic-pool"
  target_resource_id = module.sql_server.resource_elasticpools.elasticpool1.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      # log = [
      #   #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      # ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["Basic", true, false, 7],
        ["InstanceAndAppAdvanced", true, false, 7],
      ]
    }
  }
}

