module "diagnosticsetting1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-cosmos-db"
  target_resource_id = module.cosmos_db.cosmosdb_id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["DataPlaneRequests", true, false, 7],
        ["MongoRequests", true, false, 7],
        ["QueryRuntimeStatistics", true, false, 7],
        ["PartitionKeyStatistics", true, false, 7],
        ["PartitionKeyRUConsumption", true, false, 7],
        ["ControlPlaneRequests", true, false, 7],
        ["CassandraRequests", true, false, 7],
        ["GremlinRequests", true, false, 7],
        ["TableApiRequests", true, false, 7],
      ]
      metric = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        # ["AllMetrics", true, false, 7],
        ["Requests", true, false, 7],
      ]
    }
  }
}
