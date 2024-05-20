
# resource "azurecaf_name" "app_service" {
#   name          = var.name
#   resource_type = "azurerm_app_service"
#   prefixes      = var.global_settings.prefixes
#   random_length = var.global_settings.random_length
#   clean_input   = true
#   passthrough   = var.global_settings.passthrough
#   use_slug      = var.global_settings.use_slug
# }


# Per options https://www.terraform.io/docs/providers/azurerm/r/app_service.html

resource "azurerm_app_service" "app_service" {
  name                = var.name # azurecaf_name.app_service.result
  location            = var.location # local.location
  resource_group_name = var.resource_group_name # local.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  tags                = var.tags # merge(local.tags, try(var.settings.tags, {}))

  client_affinity_enabled = try(var.client_affinity_enabled, null) # lookup(var.settings, "client_affinity_enabled", null)
  client_cert_enabled     = try(var.client_cert_enabled, null) # lookup(var.settings, "client_cert_enabled", null)
  enabled                 = try(var.enabled, null) # lookup(var.settings, "enabled", null)
  https_only              = try(var.https_only, null) # lookup(var.settings, "https_only", null)

  dynamic "identity" {
    for_each = try(var.identity, null) == null ? [] : [1]

    content {
      type         = var.identity.type
      identity_ids = try(var.identity.identity_ids,null) # lower(var.identity.type) == "userassigned" ? local.managed_identities : null
    }
  }

  key_vault_reference_identity_id = try(var.key_vault_reference_identity_id, null) # can(var.settings.key_vault_reference_identity.key) ? var.combined_objects.managed_identities[try(var.settings.identity.lz_key, var.client_config.landingzone_key)][var.settings.key_vault_reference_identity.key].id : try(var.settings.key_vault_reference_identity.id, null)

  dynamic "site_config" {
    # for_each = lookup(var.settings, "site_config", {}) != {} ? [1] : []
    for_each = try(var.site_config, null) != null ? [1] : []

    content {
      always_on                 = lookup(var.site_config, "always_on", false)
      app_command_line          = lookup(var.site_config, "app_command_line", null)
      default_documents         = lookup(var.site_config, "default_documents", null)
      dotnet_framework_version  = lookup(var.site_config, "dotnet_framework_version", null)
      ftps_state                = lookup(var.site_config, "ftps_state", "FtpsOnly")
      health_check_path         = lookup(var.site_config, "health_check_path", null)
      http2_enabled             = lookup(var.site_config, "http2_enabled", false)
      java_version              = lookup(var.site_config, "java_version", null)
      java_container            = lookup(var.site_config, "java_container", null)
      java_container_version    = lookup(var.site_config, "java_container_version", null)
      local_mysql_enabled       = lookup(var.site_config, "local_mysql_enabled", null)
      linux_fx_version          = lookup(var.site_config, "linux_fx_version", null)
      windows_fx_version        = lookup(var.site_config, "windows_fx_version", null)
      managed_pipeline_mode     = lookup(var.site_config, "managed_pipeline_mode", null)
      min_tls_version           = lookup(var.site_config, "min_tls_version", "1.2")
      php_version               = lookup(var.site_config, "php_version", null)
      python_version            = lookup(var.site_config, "python_version", null)
      remote_debugging_enabled  = lookup(var.site_config, "remote_debugging_enabled", null)
      remote_debugging_version  = lookup(var.site_config, "remote_debugging_version", null)
      use_32_bit_worker_process = lookup(var.site_config, "use_32_bit_worker_process", false)
      websockets_enabled        = lookup(var.site_config, "websockets_enabled", false)
      scm_type                  = lookup(var.site_config, "scm_type", null)
      number_of_workers         = lookup(var.site_config, "number_of_workers", 1) # can(var.numberOfWorkers) || can(var.site_config.number_of_workers) ? try(var.numberOfWorkers, var.site_config.number_of_workers) : 1

      dynamic "cors" {
        for_each = lookup(var.site_config, "cors", {}) != {} ? [1] : []

        content {
          allowed_origins     = lookup(var.site_config.cors, "allowed_origins", null)
          support_credentials = lookup(var.site_config.cors, "support_credentials", null)
        }
      }
      dynamic "ip_restriction" {
        for_each = try(var.site_config.ip_restriction, {})

        content {
          ip_address                = lookup(ip_restriction.value, "ip_address", null)
          service_tag               = lookup(ip_restriction.value, "service_tag", null)
          virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null) # can(ip_restriction.value.virtual_network_subnet_id) || can(ip_restriction.value.virtual_network_subnet.id) || can(ip_restriction.value.virtual_network_subnet.subnet_key) == false ? try(ip_restriction.value.virtual_network_subnet_id, ip_restriction.value.virtual_network_subnet.id, null) : var.combined_objects.networking[try(ip_restriction.value.virtual_network_subnet.lz_key, var.client_config.landingzone_key)][ip_restriction.value.virtual_network_subnet.vnet_key].subnets[ip_restriction.value.virtual_network_subnet.subnet_key].id
          name                      = lookup(ip_restriction.value, "name", null)
          priority                  = lookup(ip_restriction.value, "priority", null)
          action                    = lookup(ip_restriction.value, "action", null)
          dynamic "headers" {
            for_each = try(ip_restriction.headers, {})

            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
            }
          }
        }
      }
    }
  }

  app_settings = var.app_settings # local.app_settings

  dynamic "connection_string" {
    # for_each = var.connection_strings
    for_each = try(var.connection_strings, null) != null ? [1] : []
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "auth_settings" {
    # for_each = lookup(var.settings, "auth_settings", {}) != {} ? [1] : []
    for_each = try(var.auth_settings, null) != null ? [1] : []
    content {
      enabled                        = lookup(var.auth_settings, "enabled", false)
      additional_login_params        = lookup(var.auth_settings, "additional_login_params", null)
      allowed_external_redirect_urls = lookup(var.auth_settings, "allowed_external_redirect_urls", null)
      default_provider               = lookup(var.auth_settings, "default_provider", null)
      issuer                         = lookup(var.auth_settings, "issuer", null)
      runtime_version                = lookup(var.auth_settings, "runtime_version", null)
      token_refresh_extension_hours  = lookup(var.auth_settings, "token_refresh_extension_hours", null)
      token_store_enabled            = lookup(var.auth_settings, "token_store_enabled", null)
      unauthenticated_client_action  = lookup(var.auth_settings, "unauthenticated_client_action", null)

      dynamic "active_directory" {
        for_each = lookup(var.auth_settings, "active_directory", {}) != {} ? [1] : []

        content {
          client_id         = lookup(var.auth_settings.active_directory, "client_id", null) # can(var.auth_settings.active_directory.client_id_key) ? var.azuread_applications[try(var.auth_settings.active_directory.client_id_lz_key, var.client_config.landingzone_key)][var.auth_settings.active_directory.client_id_key].application_id : var.auth_settings.active_directory.client_id
          client_secret     = lookup(var.auth_settings.active_directory, "client_secret", null) # can(var.auth_settings.active_directory.client_secret_key) ? var.azuread_service_principal_passwords[try(var.auth_settings.active_directory.client_secret_lz_key, var.client_config.landingzone_key)][var.auth_settings.active_directory.client_secret_key].service_principal_password : try(var.auth_settings.active_directory.client_secret, null)
          allowed_audiences = lookup(var.auth_settings.active_directory, "allowed_audiences", null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(var.auth_settings, "facebook", {}) != {} ? [1] : []

        content {
          app_id       = var.auth_settings.facebook.app_id
          app_secret   = var.auth_settings.facebook.app_secret
          oauth_scopes = lookup(var.auth_settings.facebook, "oauth_scopes", null)
        }
      }

      dynamic "google" {
        for_each = lookup(var.auth_settings, "google", {}) != {} ? [1] : []

        content {
          client_id     = var.auth_settings.google.client_id
          client_secret = var.auth_settings.google.client_secret
          oauth_scopes  = lookup(var.auth_settings.google, "oauth_scopes", null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(var.auth_settings, "microsoft", {}) != {} ? [1] : []

        content {
          client_id     = var.auth_settings.microsoft.client_id
          client_secret = var.auth_settings.microsoft.client_secret
          oauth_scopes  = lookup(var.auth_settings.microsoft, "oauth_scopes", null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(var.auth_settings, "twitter", {}) != {} ? [1] : []

        content {
          consumer_key    = var.auth_settings.twitter.consumer_key
          consumer_secret = var.auth_settings.twitter.consumer_secret
        }
      }
    }
  }

  dynamic "storage_account" {
    # for_each = lookup(var.settings, "storage_account", [])
    for_each = try(var.storage_account, null) != null ? [1] : [] 
    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = lookup(storage_account.value, "account_name", null) # can(storage_account.value.account_key) ? var.storage_accounts[try(storage_account.value.lz_key, var.client_config.landingzone_key)][storage_account.value.account_key].name : try(storage_account.value.account_name, null)
      share_name   = storage_account.value.share_name
      access_key   = lookup(storage_account.value, "access_key", null) # can(storage_account.value.account_key) ? var.storage_accounts[try(storage_account.value.lz_key, var.client_config.landingzone_key)][storage_account.value.account_key].primary_access_key : try(storage_account.value.access_key, null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  dynamic "backup" {
    # for_each = lookup(var.settings, "backup", {}) != {} ? [1] : []
    for_each = try(var.backup, null) != null ? [1] : []

    content {
      name                = var.backup.name
      enabled             = var.backup.enabled
      storage_account_url = try(var.backup.storage_account_url, null) # try(var.backup.storage_account_url, local.backup_sas_url)

      dynamic "schedule" {
        for_each = lookup(var.backup, "schedule", {}) != {} ? [1] : []

        content {
          frequency_interval       = var.backup.schedule.frequency_interval
          frequency_unit           = lookup(var.backup.schedule, "frequency_unit", null)
          keep_at_least_one_backup = lookup(var.backup.schedule, "keep_at_least_one_backup", null)
          retention_period_in_days = lookup(var.backup.schedule, "retention_period_in_days", null)
          start_time               = lookup(var.backup.schedule, "start_time", null)
        }
      }
    }
  }

  dynamic "logs" {
    # for_each = lookup(var.settings, "logs", {}) != {} ? [1] : []
    for_each = try(var.logs, null) != null ? [1] : []

    content {
      detailed_error_messages_enabled = try(var.logs.detailed_error_messages_enabled, null)
      failed_request_tracing_enabled  = try(var.logs.failed_request_tracing_enabled, null)

      dynamic "application_logs" {
        for_each = lookup(var.logs, "application_logs", {}) != {} ? [1] : []

        content {
          file_system_level = try(var.logs.application_logs.file_system_level, null)

          dynamic "azure_blob_storage" {
            for_each = lookup(var.logs.application_logs, "azure_blob_storage", {}) != {} ? [1] : []

            content {
              level             = var.logs.application_logs.azure_blob_storage.level
              sas_url           = var.logs.application_logs.azure_blob_storage.sas_url # try(var.logs.application_logs.azure_blob_storage.sas_url, local.logs_sas_url)
              retention_in_days = var.logs.application_logs.azure_blob_storage.retention_in_days
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(var.logs, "http_logs", {}) != {} ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(var.logs.http_logs, "azure_blob_storage", {}) != {} ? [1] : []

            content {
              sas_url           = var.logs.http_logs.azure_blob_storage.sas_url # try(var.logs.http_logs.azure_blob_storage.sas_url, local.http_logs_sas_url)
              retention_in_days = var.logs.http_logs.azure_blob_storage.retention_in_days
            }
          }
          dynamic "file_system" {
            for_each = lookup(var.logs.http_logs, "file_system", {}) != {} ? [1] : []

            content {
              retention_in_days = var.logs.http_logs.file_system.retention_in_days
              retention_in_mb   = var.logs.http_logs.file_system.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "source_control" {
    # for_each = lookup(var.settings, "source_control", {}) != {} ? [1] : []
    for_each = try(var.source_control,null) != null ? [1] : []

    content {
      repo_url           = var.source_control.repo_url
      branch             = lookup(var.source_control, "branch", null)
      manual_integration = lookup(var.source_control, "manual_integration", null)
      rollback_enabled   = lookup(var.source_control, "rollback_enabled", null)
      use_mercurial      = lookup(var.source_control, "use_mercurial", null)
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      site_config[0].scm_type
    ]
  }
}

# resource "azurerm_app_service_custom_hostname_binding" "app_service" {
#   for_each            = try(var.custom_hostname_binding, {})
#   app_service_name    = azurerm_app_service.app_service.name
#   resource_group_name = var.resource_group_name
#   hostname            = each.value.hostname
#   ssl_state           = try(each.value.ssl_state, null)
#   thumbprint          = try(each.value.thumbprint, null)
# }