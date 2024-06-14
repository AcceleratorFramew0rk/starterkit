# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed.  If null, the location will be inferred from the resource group location."
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the this resource."
  validation {
    condition     = var.name == null ? true : can(regex("^[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "The name must be between 2 and 63 characters long, must start and end with a lowercase letter or number, and can container lowercase letters, numbers and hyphens."
  }
  default = null
}

  # publisher_name      = var.publisher_name # var.settings.publisher_name
  # publisher_email     = var.publisher_email # var.settings.publisher_email
  # sku_name            = var.sku_name # var.settings.sku_name


variable "publisher_name" {
  type        = string
  description = "Descript the variable here"
  default     = null
}

variable "publisher_email" {
  type        = string
  description = "Descript the variable here"
  default     = null
}

variable "sku_name" {
  type        = string
  description = "Descript the variable here"
  default     = null
}

variable "additional_location" {
  description = "Descript the variable here"
  default     = null
}
variable "virtual_network_configuration" {
  description = "Descript the variable here"
  default     = null
}

# certificate
#   client_certificate_enabled = try(var.client_certificate_enabled, null) # try(var.settings.client_certificate_enabled, null)
#   gateway_disabled           = try(var.gateway_disabled, null) # try(var.settings.gateway_disabled, null)
#   min_api_version            = try(var.min_api_version, null) # try(var.settings.min_api_version, null)
#   zones                      = try(var.zones, null) # try(var.settings.zones, null)
variable "certificate" {
  description = "Descript the variable here"
  default     = null
}
variable "client_certificate_enabled" {
  description = "Descript the variable here"
  default     = null
}
variable "gateway_disabled" {
  description = "Descript the variable here"
  default     = null
}
variable "min_api_version" {
  description = "Descript the variable here"
  default     = null
}
variable "zones" {
  description = "Descript the variable here"
  default     = null
}

# identity
# hostname_configuration
# management
# portal
# developer_portal
# proxy
# scm
# notification_sender_email
# policy
variable "identity" {
  description = "Descript the variable here"
  default     = null
}
variable "hostname_configuration" {
  description = "Descript the variable here"
  default     = null
}
variable "management" {
  description = "Descript the variable here"
  default     = null
}
variable "portal" {
  description = "Descript the variable here"
  default     = null
}
variable "developer_portal" {
  description = "Descript the variable here"
  default     = null
}
variable "proxy" {
  description = "Descript the variable here"
  default     = null
}
variable "scm" {
  description = "Descript the variable here"
  default     = null
}
variable "notification_sender_email" {
  description = "Descript the variable here"
  default     = null
}
variable "policy" {
  description = "Descript the variable here"
  default     = null
}

# protocols
# security
# sign_in
# sign_up
# tenant_access
# virtual_network_type
# virtual_network_configuration
# tags

variable "protocols" {
  description = "Descript the variable here"
  default     = null
}
variable "security" {
  description = "Descript the variable here"
  default     = null
}
variable "sign_in" {
  description = "Descript the variable here"
  default     = null
}
variable "sign_up" {
  description = "Descript the variable here"
  default     = null
}
variable "tenant_access" {
  description = "Descript the variable here"
  default     = null
}
variable "virtual_network_type" {
  description = "Descript the variable here"
  default     = null
}
variable "tags" {
  description = "Descript the variable here"
  default     = null
}
variable "terms_of_service" {
  description = "Descript the variable here"
  default     = null
}
