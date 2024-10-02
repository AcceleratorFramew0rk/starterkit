# locals {
#   backup_storage_account = module.storageaccount.resource # can(var.settings.backup) ? var.storage_accounts[try(var.settings.backup.lz_key, var.client_config.landingzone_key)][var.settings.backup.storage_account_key] : null
#   backup_sas_url         = "${local.backup_storage_account.primary_blob_endpoint}${local.backup_storage_account.containers["backup"].name}${data.azurerm_storage_account_blob_container_sas.backup[0].sas}" : null

#   # logs_storage_account = can(var.settings.logs) ? var.storage_accounts[try(var.settings.logs.lz_key, var.client_config.landingzone_key)][var.settings.logs.storage_account_key] : null
#   # logs_sas_url         = can(var.settings.logs) ? "${local.logs_storage_account.primary_blob_endpoint}${local.logs_storage_account.containers[var.settings.logs.container_key].name}${data.azurerm_storage_account_blob_container_sas.logs[0].sas}" : null

#   # http_logs_storage_account = can(var.settings.logs.http_logs) ? var.storage_accounts[try(var.settings.logs.http_logs.lz_key, var.client_config.landingzone_key)][var.settings.logs.http_logs.storage_account_key] : null
#   # http_logs_sas_url         = can(var.settings.logs.http_logs) ? "${local.http_logs_storage_account.primary_blob_endpoint}${local.http_logs_storage_account.containers[var.settings.logs.http_logs.container_key].name}${data.azurerm_storage_account_blob_container_sas.http_logs[0].sas}" : null
# }
