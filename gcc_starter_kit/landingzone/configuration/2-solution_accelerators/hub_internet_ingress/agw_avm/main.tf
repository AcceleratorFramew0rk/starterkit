module "public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  name                = module.naming.public_ip.name_unique
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
  sku = "Standard"
}

module "application_gateway" {
  source  = "Azure/avm-res-network-applicationgateway/azurerm"
  version = "0.3.0"

  name = "${module.naming.application_gateway.name}${random_string.this.result}" 
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  enable_telemetry    = var.enable_telemetry

  gateway_ip_configuration = {
    subnet_id = try(local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets[var.subnet_name].resource.id : var.subnet_id  # azurerm_subnet.backend.id
  }

  # WAF : Azure Application Gateways v2 are always deployed in a highly available fashion with multiple instances by default. Enabling autoscale ensures the service is not reliant on manual intervention for scaling.
  sku = {
    # Accpected value for names Standard_v2 and WAF_v2
    name = "WAF_v2"
    # Accpected value for tier Standard_v2 and WAF_v2
    tier = "WAF_v2"
    # Accpected value for capacity 1 to 10 for a V1 SKU, 1 to 100 for a V2 SKU
    capacity = 2 # 0 # Set the initial capacity to 0 for autoscaling
  }

  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 10
  }

  ## Option to create a new public IP or use an existing one
  public_ip_resource_id = module.public_ip.public_ip_id # azurerm_public_ip.public_ip.id
  create_public_ip      = false

  frontend_ip_configuration_private = {
    name                 = "private" 
    private_ip_address            = try(cidrhost(local.global_settings.subnets.hub_internet_ingress.AgwSubnet.address_prefixes.0, 10), null) # (agw subnet cidr 100.127.0.64/27, offset 10) >"100.127.0.74" 
    private_ip_address_allocation = "Static" # Dynamic and Static default to Dynamic
    private_link_configuration_name = null
    subnet_id                     = try(local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_internet_ingress.virtual_subnets[var.subnet_name].resource.id : var.subnet_id  
  }

  # frontend port configuration block for the application gateway
  # WAF : This example NO HTTPS, We recommend to  Secure all incoming connections using HTTPS for production services with end-to-end SSL/TLS or SSL/TLS termination at the Application Gateway to protect against attacks and ensure data remains private and encrypted between the web server and browsers.
  # WAF : Please refer kv_selfssl_waf_https_app_gateway example for HTTPS configuration
  frontend_ports = var.frontend_ports

  # Backend address pool configuration for the application gateway
  # Mandatory Input
  backend_address_pools = var.backend_address_pools

  # Backend http settings configuration for the application gateway
  # Mandatory Input
  backend_http_settings = var.backend_http_settings

  # Http Listerners configuration for the application gateway
  # Mandatory Input
  http_listeners = var.http_listeners

  # WAF : Use Application Gateway with Web Application Firewall (WAF) in an application virtual network to safeguard inbound HTTP/S internet traffic. WAF offers centralized defense against potential exploits through OWASP core rule sets-based rules.
  # Ensure that you have a WAF policy created before enabling WAF on the Application Gateway
  # The use of an external WAF policy is recommended rather than using the classic WAF via the waf_configuration block.
  app_gateway_waf_policy_resource_id = azurerm_web_application_firewall_policy.azure_waf.id

  # Routing rules configuration for the backend pool
  # Mandatory Input
  request_routing_rules = var.request_routing_rules

  # WAF : Monitor and Log the configurations and traffic
  diagnostic_settings = {
    example_setting = {
      name                           = "${module.naming.application_gateway.name_unique}-diagnostic-setting"
      workspace_resource_id          = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id # azurerm_log_analytics_workspace.log_analytics_workspace.id
      log_analytics_destination_type = "Dedicated" # Or "AzureDiagnostics"
      # log_categories                 = ["Application Gateway Access Log", "Application Gateway Performance Log", "Application Gateway Firewall Log"]
      log_groups        = ["allLogs"]
      metric_categories = ["AllMetrics"]
    }
  }

  # # OPTIONAL: Classic WAF configuration (recommended to use an external WAF policy)
  # waf_configuration = {
  #   enabled                  = true
  #   firewall_mode            = "Prevention" # or Detection
  #   rule_set_type            = "OWASP"      # OWASP
  #   rule_set_version         = "3.1"        # OWASP(2.2.9, 3.0, 3.1, 3.2)
  #   file_upload_limit_mb     = 100
  #   request_body_check       = true
  #   max_request_body_size_kb = 128

  #   # Optional
  #   disabled_rule_groups = {
  #     general = {
  #       rule_group_name = "General"
  #       rules           = ["200004"]
  #     }
  #     # Disable a spacific rule in the rule group
  #     REQUEST-913-SCANNER-DETECTION = {
  #       rule_group_name = "REQUEST-913-SCANNER-DETECTION"
  #       rules           = ["913102"]
  #     }
  #     # Disable all rule in the rule group
  #     REQUEST-930-APPLICATION-ATTACK-LFI = {
  #       rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
  #     }
  #   }

  #   # Optional
  #   exclusions = {
  #     exc1 = {
  #       match_variable          = "RequestHeaderNames"
  #       selector_match_operator = "Equals" # StartsWith, EndsWith, Contains
  #       selector                = "SomeHeader"
  #     }
  #   }
  # }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "hub internet reverse proxy" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "hub internet"
      tier = "na"   
    }
  )


  depends_on = [
    module.public_ip
  ]
  
}


