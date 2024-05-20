# resource "azurerm_container_group" "this" {
#   name                = var.name # "example-continst"
#   location            = var.location # azurerm_resource_group.example.location
#   resource_group_name = var.resource_group_name # azurerm_resource_group.example.name
#   ip_address_type     = var.ip_address_type # "Public"
#   dns_name_label      = var.dns_name_label # "aci-label"
#   os_type             = var.os_type # "Linux"

#   container {
#     name   = "hello-world"
#     image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
#     cpu    = "0.5"
#     memory = "1.5"

#     ports {
#       port     = 443
#       protocol = "TCP"
#     }
#   }

#   container {
#     name   = "sidecar"
#     image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
#     cpu    = "0.5"
#     memory = "1.5"
#   }

#   tags = {
#     environment = "testing"
#   }
# }

resource "azurerm_container_group" "this" {
  # count = module.this.enabled ? 1 : 0
  location                        = var.location
  name                            = var.name
  resource_group_name             = var.resource_group_name
  sku = var.sku
  ip_address_type     = var.ip_address_type # try(var.subnet_ids, null) == null ? "Public" : "Private"
  subnet_ids          = try(var.subnet_ids, null) == null ? null : var.subnet_ids
  restart_policy      = try(var.restart_policy, null)

  dynamic "identity" {
    for_each = var.identity != null ? { this = var.identity } : {}    
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

# init_container
  dynamic "container" {
    for_each = var.containers
    content {
      name   = container.key
      image  = try(container.value.image, null)
      cpu    = container.value.cpu
      memory = container.value.memory

      dynamic "ports" {
        # for_each = try(container.value.ports, null) != null ? {this = container.value.ports} : {}   
        # for_each = try(container.value.ports, null) != null ? [container.value.ports] : []    
        for_each = container.value.ports            
        content {
          port     = ports.value.port
          protocol = try(ports.value.protocol, null)
        }
      }

      dynamic "volume" {
        # for_each = container.value.volumes
        for_each = container.value.volumes          
        content {
          mount_path = volume.value.mount_path
          name       = volume.key
          read_only  = try(volume.value.read_only, null)
          empty_dir  = try(volume.value.empty_dir, null)
          # TODO: check the below logic
          secret     = try(volume.value.secret, null)
          # secret = merge(volume.value.secret, { for k, v in volume.value.secret_from_key_vault :
          #   k => base64encode(
          #     data.azurerm_key_vault_secret.volume_secret["${container.key}/${volume.key}/${v.name}"].value
          #   )
          # })
          storage_account_name = try(volume.value.storage_account_name, null)
          storage_account_key  = try(volume.value.storage_account_key, null)
          share_name           = try(volume.value.share_name, null)

          dynamic "git_repo" {
            for_each = try(volume.value.git_repo, null) != null ? [volume.value.git_repo] : []
            content {
              url       = git_repo.value.url
              directory = git_repo.value.directory
              revision  = git_repo.value.revision
            }
          }
        }
      }

      environment_variables = try(container.value.environment_variables, null)
      # TODO: check the below
      # secure_environment_variables = merge(
      #   {
      #     for variable_name, variable in container.value.secure_environment_variables_from_key_vault : variable_name =>
      #     data.azurerm_key_vault_secret.container_secret[format("%s/%s", container.key, variable_name)].value
      #   },
      #   container.value.secure_environment_variables
      # )
      commands = try(container.value.commands, null)
    }
  }

  os_type             = var.os_type # "Linux"
  dynamic "dns_config" {
    # for_each = toset(length(var.dns_name_servers) > 0 ? [var.dns_name_servers] : [])
    for_each = var.dns_name_servers != null ? [var.dns_name_servers] : []    
    content {
      nameservers = dns_config.value
    }
  }
  dynamic "diagnostics" {
    for_each = var.container_diagnostics_log_analytics != null ? [var.container_diagnostics_log_analytics] : []
    content {
      log_analytics {
        workspace_id  = diagnostics.value.workspace_id
        workspace_key = diagnostics.value.workspace_key
      }
    }
  }

  dns_name_label      = try(var.dns_name_label, null) # length(var.subnet_ids) == 0 ? (var.dns_name_label != null ? var.dns_name_label : local.name_from_descriptor) : null
# dns_name_label_reuse_policy

  dynamic "exposed_port" {
    # for_each = var.exposed_ports
    for_each = var.exposed_ports != null ? { this = var.exposed_ports } : {}    
    content {
      port     = exposed_port.value.port
      protocol = exposed_port.value.protocol
    }
  }

  dynamic "image_registry_credential" {
    # for_each = var.image_registry_credential
    for_each = var.image_registry_credential != null ? { this = var.image_registry_credential } : {}       
    content {
      password = image_registry_credential.value.password
      server   = image_registry_credential.value.server
      username = image_registry_credential.value.username
    }
  }

  tags = var.tags

}

# resource "azurerm_key_vault" "this" {
#   location                        = var.location
#   name                            = var.name
#   resource_group_name             = var.resource_group_name
#   sku_name                        = var.sku_name
#   tenant_id                       = var.tenant_id
#   enable_rbac_authorization       = true
#   enabled_for_deployment          = var.enabled_for_deployment
#   enabled_for_disk_encryption     = var.enabled_for_disk_encryption
#   enabled_for_template_deployment = var.enabled_for_template_deployment
#   public_network_access_enabled   = var.public_network_access_enabled
#   purge_protection_enabled        = var.purge_protection_enabled
#   soft_delete_retention_days      = var.soft_delete_retention_days
#   tags                            = var.tags

#   dynamic "contact" {
#     for_each = var.contacts
#     content {
#       email = contact.value.email
#       name  = contact.value.name
#       phone = contact.value.phone
#     }
#   }
#   # Only one network_acls block is allowed.
#   # Create it if the variable is not null.
#   dynamic "network_acls" {
#     for_each = var.network_acls != null ? { this = var.network_acls } : {}
#     content {
#       bypass                     = network_acls.value.bypass
#       default_action             = network_acls.value.default_action
#       ip_rules                   = network_acls.value.ip_rules
#       virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
#     }
#   }
# }

# resource "azurerm_management_lock" "this" {
#   count = var.lock.kind != "None" ? 1 : 0

#   lock_level = var.lock.kind
#   name       = coalesce(var.lock.name, "lock-${var.name}")
#   scope      = azurerm_key_vault.this.id
# }

# resource "azurerm_role_assignment" "this" {
#   for_each = var.role_assignments

#   principal_id                           = each.value.principal_id
#   scope                                  = azurerm_key_vault.this.id
#   condition                              = each.value.condition
#   condition_version                      = each.value.condition_version
#   delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
#   role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
#   role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
#   skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
# }

# resource "azurerm_monitor_diagnostic_setting" "this" {
#   for_each = var.diagnostic_settings

#   name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
#   target_resource_id             = azurerm_key_vault.this.id
#   eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
#   eventhub_name                  = each.value.event_hub_name
#   log_analytics_destination_type = each.value.log_analytics_destination_type
#   log_analytics_workspace_id     = each.value.workspace_resource_id
#   partner_solution_id            = each.value.marketplace_partner_resource_id
#   storage_account_id             = each.value.storage_account_resource_id

#   dynamic "enabled_log" {
#     for_each = each.value.log_categories
#     content {
#       category = enabled_log.value
#     }
#   }
#   dynamic "enabled_log" {
#     for_each = each.value.log_groups
#     content {
#       category_group = enabled_log.value
#     }
#   }
#   dynamic "metric" {
#     for_each = each.value.metric_categories
#     content {
#       category = metric.value
#     }
#   }
# }
