variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "backend_address_pool" {
  description = " - (Required) One or more backend_address_pool blocks as defined below."
  default = null
}

variable "backend_http_settings" {
  description = " - (Required) One or more backend_http_settings blocks as defined below."
  default = null
}

variable "frontend_ip_configuration" {
  description = " - (Required) One or more frontend_ip_configuration blocks as defined below."
  default = null
}

variable "frontend_port" {
  description = " - (Required) One or more frontend_port blocks as defined below."
  default = null
}

variable "gateway_ip_configuration" {
  description = " - (Required) One or more gateway_ip_configuration blocks as defined below"
  default = null
}

variable "http_listener" {
  description = " - (Required) One or more http_listener blocks as defined below"
  default = null
}

variable "request_routing_rule" {
  description = " - (Required) One or more request_routing_rule blocks as defined below"
  default = null
}

variable "sku" {
  description = " - (Required) A sku block as defined below"
  default = null
}

variable "fips_enabled" {
  description = " - (Optional) Is FIPS enabled on the Application Gateway?"
  default = null
}

variable "global" {
  description = " - (Optional) A global block as defined below"
  default = null
}

variable "identity" {
  description = " - (Optional) An identity block as defined below"
  default = null
}

variable "private_link_configuration" {
  description = " - (Optional) One or more private_link_configuration blocks as defined below"
  default = null
}

variable "zones" {
  description = " - (Optional) Specifies a list of Availability Zones in which this Application Gateway should be located. Changing this forces a new Application Gateway to be created."
  default = null
}

variable "trusted_client_certificate" {
  description = " - (Optional) One or more trusted_client_certificate blocks as defined below"
  default = null
}

variable "ssl_profile" {
  description = " - (Optional) One or more ssl_profile blocks as defined below"
  default = null
}

variable "authentication_certificate" {
  description = " - (Optional) One or more authentication_certificate blocks as defined below"
  default = null
}

variable "trusted_root_certificate" {
  description = " - (Optional) One or more trusted_root_certificate blocks as defined below"
  default = null
}

variable "ssl_policy" {
  description = " - (Optional) a ssl_policy block as defined below"
  default = null
}

variable "enable_http2" {
  description = " - (Optional) Is HTTP2 enabled on the application gateway resource? Defaults to false"
  default = null
}

variable "force_firewall_policy_association" {
  description = " - (Optional) Is the Firewall Policy associated with the Application Gateway"
  default = null
}

variable "probe" {
  description = " - (Optional) One or more probe blocks as defined below"
  default = null
}

variable "ssl_certificate" {
  description = " - (Optional) One or more ssl_certificate blocks as defined below"
  default = null
}

variable "tags" {
  description = " - (Optional) A mapping of tags to assign to the resource"
  default = null
}

variable "url_path_map" {
  description = " - (Optional) One or more url_path_map blocks as defined below"
  default = null
}

variable "waf_configuration" {
  description = " - (Optional) A waf_configuration block as defined below"
  default = null
}

variable "custom_error_configuration" {
  description = " - (Optional) One or more custom_error_configuration blocks as defined below"
  default = null
}

variable "firewall_policy_id" {
  description = " - (Optional) The ID of the Web Application Firewall Policy"
  default = null
}

variable "redirect_configuration" {
  description = " - (Optional) One or more redirect_configuration blocks as defined below"
  default = null
}

variable "autoscale_configuration" {
  description = " - (Optional) An autoscale_configuration block as defined below"
  default = null
}

variable "rewrite_rule_set" {
  description = " - (Optional) One or more rewrite_rule_set blocks as defined below. Only valid for v2 SKUs"
  default = null
}
