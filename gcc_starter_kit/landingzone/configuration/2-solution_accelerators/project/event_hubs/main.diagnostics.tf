# module "diagnosticsetting1" {
#   source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

#   name                = "${module.naming.monitor_diagnostic_setting.name_unique}-eventhub"
#   target_resource_id = module.event_hubs.eventhub_namespace_id
#   log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
#   diagnostics = {
#     categories = {
#       log = [
#         # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
#         ["DiagnosticErrorLogs", true, false, 7],
#         ["ArchiveLogs", true, false, 7],
#         ["OperationalLogs", true, false, 7],
#         ["AutoScaleLogs", true, false, 7],
#         ["KafkaCoordinatorLogs", true, false, 7],
#         ["KafkaUserErrorLogs", true, false, 7],
#         ["EventHubVNetConnectionEvent", true, false, 7],
#         ["CustomerManagedKeyUserLogs", true, false, 7],
#         ["RuntimeAuditLogs", true, false, 7],
#         ["ApplicationMetricsLogs", true, false, 7],
#         ["DataDRLogs", true, false, 7],
#       ]
#       metric = [
#         # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
#         ["AllMetrics", true, false, 7],
#       ]
#     }
#   }
# }
