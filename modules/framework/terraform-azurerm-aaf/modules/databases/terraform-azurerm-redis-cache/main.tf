
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                = var.name 
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = try(var.capacity, null)
  family              = var.family
  sku_name            = var.sku_name
  tags                = var.tags # merge(local.tags, try(var.tags, null))

  enable_non_ssl_port           = try(var.enable_non_ssl_port, null)
  minimum_tls_version           = try(var.minimum_tls_version, "1.2")
  private_static_ip_address     = try(var.private_static_ip_address, null)
  public_network_access_enabled = try(var.public_network_access_enabled, null)
  shard_count                   = try(var.shard_count, null)
  replicas_per_master           = try(var.replicas_per_master, null)
  replicas_per_primary          = try(var.replicas_per_primary, null)
  zones                         = try(var.zones, null)
  redis_version                 = try(var.redis_version, null)
  subnet_id                     = try(var.subnet_id, null)

  dynamic "redis_configuration" {
    for_each = try(var.redis_configuration, {}) != {} ? [var.redis_configuration] : []

    content {
      aof_backup_enabled              = lookup(redis_configuration.value, "aof_backup_enabled", null)
      aof_storage_connection_string_0 = lookup(redis_configuration.value, "aof_storage_connection_string_0", null)
      aof_storage_connection_string_1 = lookup(redis_configuration.value, "aof_storage_connection_string_1", null)
      enable_authentication           = lookup(redis_configuration.value, "enable_authentication", null)
      maxfragmentationmemory_reserved = lookup(redis_configuration.value, "maxfragmentationmemory_reserved", null)
      maxmemory_delta                 = lookup(redis_configuration.value, "maxmemory_delta", null)
      maxmemory_policy                = lookup(redis_configuration.value, "maxmemory_policy", null)
      maxmemory_reserved              = lookup(redis_configuration.value, "maxmemory_reserved", null)
      notify_keyspace_events          = lookup(redis_configuration.value, "notify_keyspace_events", null)
      rdb_backup_enabled              = lookup(redis_configuration.value, "rdb_backup_enabled", null)
      rdb_backup_frequency            = lookup(redis_configuration.value, "rdb_backup_frequency", null)
      rdb_backup_max_snapshot_count   = lookup(redis_configuration.value, "rdb_backup_max_snapshot_count", null)
      rdb_storage_connection_string   = lookup(redis_configuration.value, "rdb_storage_connection_string", null)
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids  
    }
  }

  dynamic "patch_schedule" {
    for_each = try(var.patch_schedule, null) != null ? [var.patch_schedule] : []

    content {
      day_of_week    = patch_schedule.value.day_of_week
      start_hour_utc = lookup(patch_schedule.value, "start_hour_utc", null)
    }
  }
}
