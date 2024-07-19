# nsg diagnostics
module "diagnosticsetting1" {
  source  = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"

  for_each = try(var.subnets.project, null) == null ? local.global_settings.subnets.project : var.subnets.project

  name                = lower("${module.naming.monitor_diagnostic_setting.name_unique}-${each.value.name}")
  target_resource_id = module.network_security_groups[each.value.name].resource.id
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["NetworkSecurityGroupEvent", true, false, 7],
        ["NetworkSecurityGroupRuleCounter", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        #["AllMetrics", true, false, 7],
      ]
    }
  }
  depends_on = [
    module.virtual_subnet1,
    module.network_security_groups
  ]  
}

