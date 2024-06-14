resource "azurerm_mssql_database" "mssqldb" {
  name                                = var.name 
  server_id                           = var.server_id
  auto_pause_delay_in_minutes         = try(var.auto_pause_delay_in_minutes, null)
  create_mode                         = try(var.create_mode, null)
  creation_source_database_id         = try(var.creation_source_database_id, null)
  dynamic "import" {
    for_each = var.import == null ? [] : [1]
    content {
      storage_uri  = try(import.value.storage_uri, null) 
      storage_key  = try(import.value.storage_key, null) 
      storage_key_type  = try(import.value.storage_key_type, null) 
      administrator_login  = try(import.value.administrator_login, null) 
      administrator_login_password  = try(import.value.administrator_login_password, null) 
      authentication_type  = try(import.value.authentication_type, null) 
      storage_account_id  = try(import.value.storage_account_id, null) 
    }
  }
  collation                           = try(var.collation, null)
  elastic_pool_id                     = try(var.elastic_pool_id, null)
  enclave_type                        = try(var.enclave_type, null) 
  geo_backup_enabled                  = try(var.geo_backup_enabled, false)
  maintenance_configuration_name         = try(var.maintenance_configuration_name, null)
  ledger_enabled                      = try(var.ledger_enabled, false)
  license_type                        = try(var.license_type, null)
  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy == null ? [] : [1]
    content {
      weekly_retention  = try(long_term_retention_policy.value.weekly_retention, null) # "P7D" 
      monthly_retention = try(long_term_retention_policy.value.monthly_retention, null) # "P1M"
      yearly_retention  = try(long_term_retention_policy.value.yearly_retention, null) # "P1Y" 
      week_of_year      = try(long_term_retention_policy.value.week_of_year, null) # "1"
    }
  }
  max_size_gb                         = try(var.max_size_gb, null)
  min_capacity                        = try(var.min_capacity, null)
  restore_point_in_time               = try(var.restore_point_in_time, null)
  recover_database_id                 = try(var.recover_database_id, null)
  recovery_point_id         = try(var.recovery_point_id, null)
  restore_dropped_database_id         = try(var.restore_dropped_database_id, null)
  restore_long_term_retention_backup_id         = try(var.restore_long_term_retention_backup_id, null)
  read_replica_count                  = try(var.read_replica_count, null)
  read_scale                          = try(var.read_scale, null)
  sample_name                         = try(var.sample_name, null)
  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_policy == null ? [] : [1]
    content {
      retention_days           = try(short_term_retention_policy.value.retention_days, null) # 7  
      backup_interval_in_hours = try(short_term_retention_policy.value.backup_interval_in_hours, null) # 24  
    }
  }
  sku_name                            = try(var.sku_name, null)
  storage_account_type                = try(var.storage_account_type, null)
  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy == null ? [] : [1]
    content {
      state                      = try(threat_detection_policy.value.state, null) 
      disabled_alerts            = try(threat_detection_policy.value.disabled_alerts, null)
      email_account_admins       = try(threat_detection_policy.value.email_account_admins, null)
      email_addresses            = try(threat_detection_policy.value.email_addresses, null)
      retention_days             = try(threat_detection_policy.value.retention_days, null)
      storage_endpoint           = try(data.azurerm_storage_account.mssqldb_tdp.0.primary_blob_endpoint, null)
      storage_account_access_key = try(data.azurerm_storage_account.mssqldb_tdp.0.primary_access_key, null)
    }
  }
  dynamic "identity" {
    for_each = var.identity == null ? [] : [1]
    content {
      type = var.identity.type
      identity_ids = var.identity.identity_ids 
    }
  }
  transparent_data_encryption_enabled = try(var.transparent_data_encryption_enabled, null)
  transparent_data_encryption_key_vault_key_id         = try(var.transparent_data_encryption_key_vault_key_id, null)
  transparent_data_encryption_key_automatic_rotation_enabled         = try(var.transparent_data_encryption_key_automatic_rotation_enabled, null)
  tags                                = var.tags
  zone_redundant                      = try(var.zone_redundant, null)
}

# threat detection policy
data "azurerm_storage_account" "mssqldb_tdp" {
  count = try(var.threat_detection_policy.storage_account.key, null) == null ? 0 : 1

  name                = var.storage_accounts[var.threat_detection_policy.storage_account.key].name
  resource_group_name = var.storage_accounts[var.threat_detection_policy.storage_account.key].resource_group_name
}
