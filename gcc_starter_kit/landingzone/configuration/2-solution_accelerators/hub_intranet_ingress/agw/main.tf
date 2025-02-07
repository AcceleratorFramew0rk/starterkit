# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "default-example-beap"
  frontend_port_name             = "default-example-feport"
  frontend_ip_configuration_name = "default-example-feip"
  http_setting_name              = "default-example-be-htst"
  listener_name                  = "default-example-httplstn"
  request_routing_rule_name      = "default-example-rqrt"
  redirect_configuration_name    = "default-example-rdrcfg"
}

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
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/networking/terraform-azurerm-applicationgateway"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-applicationgateway"
  
  name                         = "${module.naming.application_gateway.name}${random_string.this.result}" 
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "hub intranet reverse proxy" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "hub intranet"
      tier = "na"   
    }
  )

  sku = {
    name     = "WAF_v2" # "Standard_v2"
    tier     = "WAF_v2" # "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration  = {  
    gateway_ip_configuration1  = {
      name      = "agw-gateway-ip-configuration"
      subnet_id = try(local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_subnets["AgwSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_subnets["AgwSubnet"].resource.id : var.subnet_id 
    }
  }
  frontend_port  = {  
    80  = {
      name = local.frontend_port_name
      port = 80
    }
  }
  frontend_ip_configuration = {
    public  = {
      name                 = local.frontend_ip_configuration_name
      public_ip_address_id = module.public_ip.public_ip_id 
      private_ip_address            = null 
      private_ip_address_allocation = null 
      subnet_id                     = null 
    }
    private  = {
      name                 = "private" 
      public_ip_address_id = null 
      private_ip_address            = try(cidrhost(local.global_settings.subnets.hub_intranet_ingress.AgwSubnet.address_prefixes.0, 10), null) # (agw subnet cidr 100.127.0.64/27, offset 10) >"100.127.0.74" 
      private_ip_address_allocation = "Static" # Dynamic and Static default to Dynamic
      subnet_id                     = try(local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_subnets["AgwSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.hub_intranet_ingress.virtual_subnets["AgwSubnet"].resource.id : var.subnet_id 
    }    
  }
  backend_address_pool = {
    beap1  = {
      name = local.backend_address_pool_name
    }
  }
  backend_http_settings  = {
    bes1  = {
      name                  = local.http_setting_name
      cookie_based_affinity = "Disabled"
      path                  = "/path1/"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 60
    }
  }
  http_listener  = {  
    http_listener1  = {
      name                           = local.listener_name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      protocol                       = "Http"
    }
  }
  request_routing_rule  = {  
    request_routing_rule1  = {
      name                       = local.request_routing_rule_name
      priority                   = 9
      rule_type                  = "Basic"
      http_listener_name         = local.listener_name
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name
    } 
  } 

  waf_configuration = {
    enabled                  = true
    firewall_mode            = "Prevention" # or Detection
    rule_set_type            = "OWASP"      # OWASP
    rule_set_version         = "3.1"        # OWASP(2.2.9, 3.0, 3.1, 3.2)
    file_upload_limit_mb     = 100
    request_body_check       = true
    max_request_body_size_kb = 128

    # Optional
    disabled_rule_groups = {
      general = {
        rule_group_name = "General"
        rules           = ["200004"]
      }
      # Disable a spacific rule in the rule group
      REQUEST-913-SCANNER-DETECTION = {
        rule_group_name = "REQUEST-913-SCANNER-DETECTION"
        rules           = ["913102"]
      }
      # Disable all rule in the rule group
      REQUEST-930-APPLICATION-ATTACK-LFI = {
        rule_group_name = "REQUEST-930-APPLICATION-ATTACK-LFI"
      }
    }

    # Optional
    exclusions = {
      exc1 = {
        match_variable          = "RequestHeaderNames"
        selector_match_operator = "Equals" # StartsWith, EndsWith, Contains
        selector                = "SomeHeader"
      }
    }
  }
}