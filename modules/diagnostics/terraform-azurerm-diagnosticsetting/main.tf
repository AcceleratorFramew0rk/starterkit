resource "azurerm_monitor_diagnostic_setting" "diagnostics" {

  name               = var.name 
  target_resource_id = var.target_resource_id 
  eventhub_name = try(var.eventhub_name, null) 
  eventhub_authorization_rule_id = try(var.eventhub_authorization_rule_id, null)
  log_analytics_workspace_id     = try(var.log_analytics_workspace_id, null) 
  log_analytics_destination_type = try(var.log_analytics_destination_type, null) 

  storage_account_id = try(var.storage_account_id, null) 

  dynamic "enabled_log" {

    for_each = {
      for key, value in try(var.diagnostics.categories.log, {}) : key => value
      if tobool(value[1]) == true
    }
    content {
      category = enabled_log.value[0]

      dynamic "retention_policy" {
        for_each = length(enabled_log.value) > 2 ? [1] : []
        content {
          enabled = enabled_log.value[2]
          # days    = enabled_log.value[3]
        }
      }
    }
  }

  dynamic "metric" {
    for_each = lookup(var.diagnostics.categories, "metric", {})
    content {
      category = metric.value[0]
      enabled  = metric.value[1]

      dynamic "retention_policy" {
        for_each = length(metric.value) > 2 ? [1] : []
        content {
          enabled = metric.value[2]
          # days    = metric.value[3]
        }
      }
    }
  }
}
