module "diagnosticsetting" {
  source = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-vnet"
  target_resource_id = module.firewall.id.id # bug in avm module which output id or name the resource object
  log_analytics_workspace_id = local.remote.log_analytics_workspace.id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AzureFirewallApplicationRule", true, false, 7],
        ["AzureFirewallNetworkRule", true, false, 7],
        ["AzureFirewallDnsProxy", true, false, 7],
        ["AZFWApplicationRule", true, false, 7],
        ["AZFWApplicationRuleAggregation", true, false, 7],
        ["AZFWDnsQuery", true, false, 7],
        ["AZFWFatFlow", true, true, 7],
        ["AZFWFlowTrace", true, true, 7],
        ["AZFWFqdnResolveFailure", true, false, 7],
        ["AZFWIdpsSignature", true, false, 7],
        ["AZFWNatRule", true, false, 7],
        ["AZFWNatRuleAggregation", true, false, 7],
        ["AZFWNetworkRule", true, false, 7],
        ["AZFWNetworkRuleAggregation", true, false, 7],
        ["AZFWThreatIntel", true, false, 7],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}
