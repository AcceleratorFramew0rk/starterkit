# nsg diagnostics
module "diagnosticsetting1" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-app"
  target_resource_id = module.nsg_app.resource.id
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
}

module "diagnosticsetting2" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-db"
  target_resource_id = module.nsg_db.resource.id
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
}

module "diagnosticsetting3" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-service"
  target_resource_id = module.nsg_service.resource.id
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
}

module "diagnosticsetting4" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-api"
  target_resource_id = module.nsg_api.resource.id
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
}

module "diagnosticsetting5" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-systemnodepoolsubnet"
  target_resource_id = module.nsg_systemnodepoolsubnet.resource.id
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
}

module "diagnosticsetting6" {
  source  = "./../../../../../../modules/diagnostics/terraform-azurerm-diagnosticsetting"

  name                = "${module.naming.monitor_diagnostic_setting.name_unique}-usernodepoolsubnet"
  target_resource_id = module.nsg_usernodepoolsubnet.resource.id
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
}