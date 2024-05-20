# fips_enabled
# private_link_configuration
resource "azurerm_application_gateway" "agw" {
  name                = var.name # azurecaf_name.agw.result
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool

    content {
      name         = backend_address_pool.value.name
      fqdns        = try(backend_address_pool.value.fqdns, null) 
      ip_addresses = try(backend_address_pool.value.ip_addresses, null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = try(backend_http_settings.value.cookie_based_affinity, null) 
      port                  = try(backend_http_settings.value.port, null) 
      protocol              = try(backend_http_settings.value.protocol, null) 
      request_timeout       = try(backend_http_settings.value.request_timeout, null) 
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration

    content {
      name                          = frontend_ip_configuration.value.name
      public_ip_address_id          = try(frontend_ip_configuration.value.public_ip_address_id, null) # try(local.ip_configuration[frontend_ip_configuration.key].ip_address_id, null)
      private_ip_address            = try(frontend_ip_configuration.value.private_ip_address, null) # try(frontend_ip_configuration.value.public_ip_key, null) == null ? var.private_ip_address : null
      private_ip_address_allocation = try(frontend_ip_configuration.value.private_ip_address_allocation, null) # Dynamic and Static default to Dynamic
      subnet_id                     = try(frontend_ip_configuration.value.subnet_id, null) # local.ip_configuration[frontend_ip_configuration.key].subnet_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration

    content {
      name      = gateway_ip_configuration.value.name 
      subnet_id = gateway_ip_configuration.value.subnet_id   
    }
  }  

  dynamic "http_listener" {
    for_each = var.http_listener

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name 
      frontend_port_name             = http_listener.value.frontend_port_name 
      protocol                       = try(http_listener.value.protocol, null) 
      host_name                      = try(http_listener.value.host_name, null) 
      host_names                     = try(http_listener.value.host_names, null) 
      require_sni                    = try(http_listener.value.require_sni, null) 
      ssl_certificate_name           = try(http_listener.value.ssl_certificate_name, null) 
      firewall_policy_id             = try(http_listener.value.firewall_policy_id, null) 
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule    

    content {
      name               = try(request_routing_rule.value.name, null) # "${try(local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.prefix, "")}${request_routing_rule.value.name}"
      rule_type          = try(request_routing_rule.value.rule_type, null) # try(local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.rule_type, "Basic")
      http_listener_name = try(request_routing_rule.value.http_listener_name, null) # request_routing_rule.value.name

      # backend_http_settings_name and backend_address_pool_name are mutually exclusive with redirect_configuration_name
      backend_http_settings_name  = try(request_routing_rule.value.backend_http_settings_name, null) # try(local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.redirect_configuration_name, null) == null ? local.backend_http_settings[request_routing_rule.value.app_key].name : null
      backend_address_pool_name   = try(request_routing_rule.value.backend_address_pool_name, null) # try(local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.redirect_configuration_name, null) == null ? local.backend_pools[request_routing_rule.value.app_key].name : null
      redirect_configuration_name = try(request_routing_rule.value.redirect_configuration_name, null) # try(local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.redirect_configuration_name, null)

      url_path_map_name = try(request_routing_rule.value.url_path_map_name, null) # try(
      rewrite_rule_set_name = try(request_routing_rule.value.rewrite_rule_set_name, null) # try(local.rewrite_rule_sets[format("%s-%s", request_routing_rule.value.app_key, local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.rewrite_rule_set_key)].name, null)
      priority              = try(request_routing_rule.value.priority, null) # try(local.request_routing_rules[format("%s-%s", request_routing_rule.value.app_key, request_routing_rule.value.request_routing_rule_key)].rule.priority, null)
    }
  }  

  sku {
    name     = try(var.sku.name, null)
    tier     = try(var.sku.tier, null)
    capacity = try(var.sku.capacity, null) # try(var.capacity.autoscale, null) == null ? var.capacity.scale_unit : null
  }
  fips_enabled   = try(var.fips_enabled, null)
  dynamic "global" {
    for_each = try(var.global, null) == null ? [] : [1]
    content {
      request_buffering_enabled = var.global.request_buffering_enabled
      response_buffering_enabled = var.global.response_buffering_enabled      
    }
  }  
  dynamic "identity" {
    for_each = try(var.identity, null) == null ? [] : [1]

    content {
      type         = "UserAssigned"
      identity_ids = var.identity.identity_ids
    }
  }
  dynamic "private_link_configuration" {
    for_each = try(var.private_link_configuration, null) == null ? [] : [1]

    content {
      name         = var.private_link_configuration.name 
      dynamic "ip_configuration" {
        for_each = try(var.private_link_configuration.ip_configuration, null) == null ? [] : [1]
        content {
          name = var.private_link_configuration.ip_configuration.name
          subnet_id = var.private_link_configuration.ip_configuration.subnet_id
          private_ip_address_allocation = var.private_link_configuration.ip_configuration.private_ip_address_allocation
          primary = var.private_link_configuration.ip_configuration.primary
          private_ip_address = var.private_link_configuration.ip_configuration.private_ip_address
        }
      }
    }
  }
  zones                             = try(var.zones, null)
  dynamic "trusted_client_certificate" {
    for_each = try(var.trusted_client_certificate, null) == null ? [] : [1]

    content {
      name         = var.var.trusted_client_certificate.name 
      data = var.var.trusted_client_certificate.data
    }
  }
  dynamic "ssl_profile" {
    for_each = try(var.ssl_profile, null) == null ? [] : [1]
    content {
      name                             = ssl_profile.value.name
      trusted_client_certificate_names = try(ssl_profile.trusted_client_certificate_names, null)
      verify_client_cert_issuer_dn     = try(ssl_profile.verify_client_cert_issuer_dn, null)

      dynamic "ssl_policy" {
        for_each = try(ssl_profile.value.ssl_policy, null) == null ? [] : [ssl_profile.value.ssl_policy]
        content {
          disabled_protocols   = try(ssl_policy.value.disabled_protocols, null)
          policy_type          = try(ssl_policy.value.policy_type, null)
          policy_name          = try(ssl_policy.value.policy_name, null)
          cipher_suites        = try(ssl_policy.value.cipher_suites, null)
          min_protocol_version = try(ssl_policy.value.min_protocol_version, null)
        }
      }
    }
  }
  dynamic "authentication_certificate" {
    for_each = try(var.authentication_certificate, null) == null ? [] : [1]

    content {
      name         = var.var.authentication_certificate.name 
      data = var.var.authentication_certificate.data
    }
  }
  dynamic "trusted_root_certificate" {
    for_each = try(var.trusted_root_certificate, null) == null ? [] : [1] 
    # {
    #   for key, value in try(var.trusted_root_certificate, {}) : key => value
    # }
    content {
      name = trusted_root_certificate.value.name
      data = trusted_root_certificate.value.data # try(trusted_root_certificate.value.data, data.azurerm_key_vault_certificate.trustedcas[trusted_root_certificate.key].certificate_data_base64)
    }
  }
  dynamic "ssl_policy" {
    for_each = try(var.ssl_policy, null) == null ? [] : [1]
    content {
      disabled_protocols   = try(var.ssl_policy.disabled_protocols, null)
      policy_type          = try(var.ssl_policy.policy_type, null)
      policy_name          = try(var.ssl_policy.policy_name, null)
      cipher_suites        = try(var.ssl_policy.cipher_suites, null)
      min_protocol_version = try(var.ssl_policy.min_protocol_version, null)
    }
  }
  enable_http2                      = try(var.enable_http2, true)
  force_firewall_policy_association = try(var.force_firewall_policy_association, null) # can(var.firewall_policy_id) == false && can(var.waf_policy.key) == false ? false : true
  dynamic "probe" {
    for_each = try(var.probe, null) == null ? [] : [1]

    content {
      name                                      = probe.value.name
      host                                      = try(probe.value.host, null)
      interval                                  = probe.value.interval
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      port                                      = try(probe.value.port, null)
      pick_host_name_from_backend_http_settings = try(probe.value.pick_host_name_from_backend_http_settings, false)
      minimum_servers                           = try(probe.value.minimum_servers, 0)
      dynamic "match" {
        for_each = try(probe.value.match, null) == null ? [] : [1]
        content {
          body        = try(probe.value.match.body, null)
          status_code = try(probe.value.match.status_code, null)
        }
      }
    }
  }
  dynamic "ssl_certificate" {
    for_each = try(var.ssl_certificate, null) == null ? [] : [1]

    content {
      name     = ssl_certificate.value.name
      data     = try(ssl_certificate.value.key_vault_secret_id, null) == null ? ssl_certificate.value.data : null
      password = try(ssl_certificate.value.data, null) != null ? ssl_certificate.value.password : null
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id # var.keyvault_certificates[ssl_certificate.value].secret_id
    }
  }
  tags = try(var.tags, null)
  dynamic "url_path_map" {
    for_each = try(var.url_path_map, null) == null ? [] : [1]
    content {
      default_backend_address_pool_name  = try(url_path_map.value.default_backend_address_pool_name, null) # try(url_path_map.value.default_backend_address_pool_name, var.application_gateway_applications[url_path_map.value.app_key].name)
      default_backend_http_settings_name = try(url_path_map.value.default_backend_http_settings_name, null) # try(url_path_map.value.default_backend_http_settings_name, var.application_gateway_applications[url_path_map.value.app_key].name)
      name                               = url_path_map.value.name
      default_rewrite_rule_set_name      = try(url_path_map.value.default_rewrite_rule_set_name, null) # try(local.rewrite_rule_sets[format("%s-%s", url_path_map.value.app_key, url_path_map.value.default_rewrite_rule_set_key)].name, null)

      dynamic "path_rule" {
        for_each = try(url_path_map.value.path_rules, [])

        content {
          backend_address_pool_name  = path_rule.value.backend_address_pool_name # try(var.application_gateway_applications[path_rule.value.backend_pool.app_key].name, var.application_gateway_applications[url_path_map.value.app_key].name)
          backend_http_settings_name = path_rule.value.backend_http_settings_name # try(var.application_gateway_applications[path_rule.value.backend_http_setting.app_key].name, var.application_gateway_applications[url_path_map.value.app_key].name)
          name                       = path_rule.value.name
          paths                      = path_rule.value.paths
          rewrite_rule_set_name      = path_rule.value.rewrite_rule_set_name # try(local.rewrite_rule_sets[format("%s-%s", url_path_map.value.app_key, path_rule.value.rewrite_rule_set_key)].name, null)
        }
      }
    }
  }

  dynamic "waf_configuration" {
    for_each = try(var.waf_configuration, null) == null ? [] : [1]
    content {
      enabled                  = var.waf_configuration.enabled
      firewall_mode            = var.waf_configuration.firewall_mode
      rule_set_type            = var.waf_configuration.rule_set_type
      rule_set_version         = var.waf_configuration.rule_set_version
      file_upload_limit_mb     = try(var.waf_configuration.file_upload_limit_mb, 100)
      request_body_check       = try(var.waf_configuration.request_body_check, true)
      max_request_body_size_kb = try(var.waf_configuration.max_request_body_size_kb, 128)
      dynamic "disabled_rule_group" {
        for_each = try(var.waf_configuration.disabled_rule_groups, {})
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = try(disabled_rule_group.value.rules, null)
        }
      }
      dynamic "exclusion" {
        for_each = try(var.waf_configuration.exclusions, {})
        content {
          match_variable          = exclusion.value.match_variable
          selector_match_operator = try(exclusion.value.selector_match_operator, null)
          selector                = try(exclusion.value.selector, null)
        }
      }
    }
  }
  dynamic "custom_error_configuration" {
    for_each = try(var.custom_error_configuration, null) == null ? [] : [1]
    content {
      status_code                  = var.custom_error_configuration.status_code
      custom_error_page_url            = var.custom_error_configuration.custom_error_page_url
    }
  }
  firewall_policy_id                = try(var.firewall_policy_id, null) # can(var.firewall_policy_id) == true ? var.firewall_policy_id : (can(var.waf_policy.key) == true ? var.application_gateway_waf_policies[try(var.waf_policy.lz_key, var.client_config.landingzone_key)][var.waf_policy.key].id : null)
  dynamic "redirect_configuration" {
    for_each = try(var.redirect_configuration, null) == null ? [] : [1]

    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = try(redirect_configuration.value.target_listener_name, null)
      target_url           = try(redirect_configuration.value.target_url, null)
      include_path         = try(redirect_configuration.value.include_path, false)
      include_query_string = try(redirect_configuration.value.include_query_string, false)
    }
  }
  dynamic "autoscale_configuration" {
    for_each = try(var.autoscale_configuration, null) == null ? [] : [1]

    content {
      min_capacity = var.autoscale_configuration.minimum_scale_unit
      max_capacity = var.autoscale_configuration.maximum_scale_unit
    }
  }
  dynamic "rewrite_rule_set" {
    for_each = try(var.rewrite_rule_set, null) == null ? [] : [1] # try(var.rewrite_rule_set)

    content {
      name = rewrite_rule_set.value.name
      dynamic "rewrite_rule" {
        for_each = try(rewrite_rule_set.value.rewrite_rules, {})
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence
          dynamic "condition" {
            for_each = try(rewrite_rule.value.conditions, {})
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = try(condition.value.ignore_case, false)
              negate      = try(condition.value.negate, false)
            }
          }
          dynamic "request_header_configuration" {
            for_each = try(rewrite_rule.value.request_header_configurations, {})
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }
          }
          dynamic "response_header_configuration" {
            for_each = try(rewrite_rule.value.response_header_configurations, {})
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }
          dynamic "url" {
            for_each = try(rewrite_rule.value.url, null) == null ? [] : [1]
            content {
              path         = try(rewrite_rule.value.url.path, null)
              query_string = try(rewrite_rule.value.url.query_string, null)
              reroute      = try(rewrite_rule.value.url.reroute, null)
            }
          }
        }
      }
    }
  }
}

