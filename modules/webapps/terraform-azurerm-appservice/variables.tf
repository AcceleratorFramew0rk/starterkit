variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "app_service_plan_id" {}
variable "tags" {}
variable "client_affinity_enabled" {}
variable "client_cert_enabled" {}
variable "enabled" {}
variable "https_only" {}
variable "identity" {}
variable "key_vault_reference_identity_id" { default = null}
variable "site_config" {}
variable "app_settings" {}
variable "connection_strings" { default = null}
variable "auth_settings" { default = null}
variable "storage_account" { default = null}
variable "backup" { default = null}
variable "logs" { default = null}
variable "source_control" { default = null}
variable "custom_hostname_binding" { default = null}



# variable "client_config" {
#   description = "Client configuration object (see module README.md)."
# }

# variable "name" {
#   description = "(Required) Name of the App Service"
# }

# variable "location" {
#   description = "(Required) Resource Location"
#   default     = null
# }
# variable "resource_group_name" {
#   description = "Resource group object to deploy the virtual machine"
#   default     = null
# }
# variable "resource_group" {
#   description = "Resource group object to deploy the virtual machine"
# }

# variable "app_service_plan_id" {
# }

# variable "identity" {
#   default = null
# }

# variable "connection_strings" {
#   default = {}
# }

# variable "app_settings" {
#   default = null
# }

# variable "dynamic_app_settings" {
#   default = {}
# }

# variable "slots" {
#   default = {}
# }

# variable "application_insight" {
#   default = null
# }

# variable "settings" {}

# variable "global_settings" {
#   description = "Global settings object (see module README.md)"
# }

# variable "base_tags" {
#   description = "Base tags for the resource to be inherited from the resource group."
#   type        = bool
# }

# variable "combined_objects" {
#   default = {}
# }
# variable "storage_accounts" {
#   default = {}
# }

# variable "diagnostic_profiles" {
#   default = {}
# }
# variable "diagnostics" {
#   default = null
# }

# variable "vnets" {}
# variable "subnet_id" {}
# variable "private_endpoints" {}
# variable "private_dns" {}
# variable "azuread_applications" {}
# variable "azuread_service_principal_passwords" {}

# variable "virtual_subnets" {
#   description = "Map of virtual_subnets objects"
#   default     = {}
#   nullable    = false
# }

