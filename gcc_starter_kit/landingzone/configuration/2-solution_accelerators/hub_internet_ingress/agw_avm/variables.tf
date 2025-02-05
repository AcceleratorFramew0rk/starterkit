# insert your variables here
variable "location" {
  type        = string  
  default = "southeastasia"
}

variable "vnet_id" {
  type        = string  
  default = null
}

variable "subnet_id" {
  type        = string  
  default = null
}

variable "log_analytics_workspace_id" {
  type        = string  
  default = null
}

variable "prefix" {
  type        = string  
  default = "aaf"
}

variable "environment" {
  type        = string  
  default = "sandpit"
}

# ---------------------------------------------------------------
# ** IMPORTANT: The variables below pertain to the Application Gateway Module and are intended for configuring application routing rules. 
# Configuration via the `tfvars` file is required.
# ---------------------------------------------------------------

# Variable declaration for the backend address pool name
variable "backend_address_pools" {
  type = map(object({
    name         = string
    fqdns        = optional(set(string))
    ip_addresses = optional(set(string))
  }))
  description = <<-DESCRIPTION
 - `name` - (Required) The name of the Backend Address Pool.
 - `fqdns` - (Optional) A list of FQDN's which should be part of the Backend Address Pool.
 - `ip_addresses` - (Optional) A list of IP Addresses which should be part of the Backend Address Pool.
DESCRIPTION
  nullable    = false
  default =  {
    appGatewayBackendPool = {
      name         = "appGatewayBackendPool"
      ip_addresses = ["100.64.2.6", "100.64.2.5"]
      #fqdns        = ["example1.com", "example2.com"]
    }
  }
}

variable "backend_http_settings" {
  type = map(object({
    cookie_based_affinity               = optional(string, "Disabled")
    name                                = string
    port                                = number
    protocol                            = string
    affinity_cookie_name                = optional(string)
    host_name                           = optional(string)
    path                                = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    probe_name                          = optional(string)
    request_timeout                     = optional(number)
    trusted_root_certificate_names      = optional(list(string))
    authentication_certificate = optional(list(object({
      name = string
    })))
    connection_draining = optional(object({
      drain_timeout_sec          = number
      enable_connection_draining = bool
    }))
  }))
  description = <<-DESCRIPTION
 - `cookie_based_affinity` - (Required) Is Cookie-Based Affinity enabled? Possible values are `Enabled` and `Disabled`.
 - `name` - (Required) The name of the Backend HTTP Settings Collection.
 - `port` - (Required) The port which should be used for this Backend HTTP Settings Collection.
 - `protocol` - (Required) The Protocol which should be used. Possible values are `Http` and `Https`.
 - `affinity_cookie_name` - (Optional) The name of the affinity cookie.
 - `host_name` - (Optional) Host header to be sent to the backend servers. Cannot be set if `pick_host_name_from_backend_address` is set to `true`.
 - `path` - (Optional) The Path which should be used as a prefix for all HTTP requests.
 - `pick_host_name_from_backend_address` - (Optional) Whether host header should be picked from the host name of the backend server. Defaults to `false`.
 - `probe_name` - (Optional) The name of an associated HTTP Probe.
 - `request_timeout` - (Optional) The request timeout in seconds, which must be between 1 and 86400 seconds. Defaults to `30`.
 - `trusted_root_certificate_names` - (Optional) A list of `trusted_root_certificate` names.

 ---
 `authentication_certificate` block supports the following:
 - `name` - (Required) The Name of the Authentication Certificate to use.

 ---
 `connection_draining` block supports the following:
 - `drain_timeout_sec` - (Required) The number of seconds connection draining is active. Acceptable values are from `1` second to `3600` seconds.
 - `enable_connection_draining` - (Required) If connection draining is enabled or not.
DESCRIPTION
  nullable    = false

  validation {
    # create a condition that checks host_name is null if pick_host_name_from_backend_address is set to true
    condition     = alltrue([for _, v in var.backend_http_settings : v.pick_host_name_from_backend_address == true ? v.host_name == null : true])
    error_message = "host_name must not be set if pick_host_name_from_backend_address is set to true."
  }

  default = {
    appGatewayBackendHttpSettings = {
      name            = "appGatewayBackendHttpSettings"
      port            = 80
      protocol        = "Http"
      path            = "/"
      request_timeout = 30
      connection_draining = {
        enable_connection_draining = true
        drain_timeout_sec          = 300
      }
    }
    # Add more http settings as needed
  }
}

# # Variable declaration for the frontend ports
variable "frontend_ports" {
  type = map(object({
    name = string
    port = number
  }))
  description = <<-DESCRIPTION
 - `name` - (Required) The name of the Frontend Port.
 - `port` - (Required) The port used for this Frontend Port.
DESCRIPTION
  nullable    = false
  
  default = {
    frontend-port-80 = {
      name = "frontend-port-80"
      port = 80
    }
  }
}

variable "http_listeners" {
  type = map(object({
    name                           = string
    frontend_port_name             = string
    frontend_ip_configuration_name = optional(string)
    firewall_policy_id             = optional(string)
    require_sni                    = optional(bool)
    host_name                      = optional(string)
    host_names                     = optional(list(string))
    ssl_certificate_name           = optional(string)
    ssl_profile_name               = optional(string)
    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })))
    # Define other attributes as needed
  }))
  description = <<-DESCRIPTION
 - `firewall_policy_id` - (Optional) The ID of the Web Application Firewall Policy which should be used for this HTTP Listener.
 - `frontend_ip_configuration_name` - (Required) The Name of the Frontend IP Configuration used for this HTTP Listener.
 - `frontend_port_name` - (Required) The Name of the Frontend Port use for this HTTP Listener.
 - `host_name` - (Optional) The Hostname which should be used for this HTTP Listener. Setting this value changes Listener Type to 'Multi site'.
 - `host_names` - (Optional) A list of Hostname(s) should be used for this HTTP Listener. It allows special wildcard characters.
 - `name` - (Required) The Name of the HTTP Listener.
 - `require_sni` - (Optional) Should Server Name Indication be Required? Defaults to `false`.
 - `ssl_certificate_name` - (Optional) The name of the associated SSL Certificate which should be used for this HTTP Listener.
 - `ssl_profile_name` - (Optional) The name of the associated SSL Profile which should be used for this HTTP Listener.

 ---
 `custom_error_configuration` block supports the following:
 - `custom_error_page_url` - (Required) Error page URL of the application gateway customer error.
 - `status_code` - (Required) Status code of the application gateway customer error. Possible values are `HttpStatus403` and `HttpStatus502`
DESCRIPTION
  nullable    = false
  default = {
    appGatewayHttpListener = {
      name               = "appGatewayHttpListener"
      host_name          = null
      frontend_port_name = "frontend-port-80"
    }
    # # Add more http listeners as needed
  }  
}

variable "request_routing_rules" {
  type = map(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    priority                    = optional(number)
    url_path_map_name           = optional(string)
    backend_http_settings_name  = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    # Define other attributes as needed
  }))
  description = <<-DESCRIPTION
 - `backend_address_pool_name` - (Optional) The Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if `redirect_configuration_name` is set.
 - `backend_http_settings_name` - (Optional) The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if `redirect_configuration_name` is set.
 - `http_listener_name` - (Required) The Name of the HTTP Listener which should be used for this Routing Rule.
 - `name` - (Required) The Name of this Request Routing Rule.
 - `priority` - (Optional) Rule evaluation order can be dictated by specifying an integer value from `1` to `20000` with `1` being the highest priority and `20000` being the lowest priority.
 - `redirect_configuration_name` - (Optional) The Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if either `backend_address_pool_name` or `backend_http_settings_name` is set.
 - `rewrite_rule_set_name` - (Optional) The Name of the Rewrite Rule Set which should be used for this Routing Rule. Only valid for v2 SKUs.
 - `rule_type` - (Required) The Type of Routing that should be used for this Rule. Possible values are `Basic` and `PathBasedRouting`.
 - `url_path_map_name` - (Optional) The Name of the URL Path Map which should be associated with this Routing Rule.
DESCRIPTION
  nullable    = false

  default = {
    routing-rule-1 = {
      name                       = "rule-1"
      rule_type                  = "Basic"
      http_listener_name         = "appGatewayHttpListener"
      backend_address_pool_name  = "appGatewayBackendPool"
      backend_http_settings_name = "appGatewayBackendHttpSettings"
      priority                   = 100
    }
    # Add more rules as needed
  }  
}