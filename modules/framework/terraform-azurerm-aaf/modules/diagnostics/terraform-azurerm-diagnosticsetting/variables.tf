
variable "name" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
}

variable "target_resource_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
}

variable "eventhub_name" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  default = null
}

variable "eventhub_authorization_rule_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  default = null
}
variable "log_analytics_workspace_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  default = null
}
variable "log_analytics_destination_type" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  default = null
}
variable "storage_account_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
  default = null
}

variable "diagnostics" {
  description = "(Required) Contains the diagnostics setting object."
}

# variable "resource_location" {
#   description = "(Required) location of the resource"
# }

# variable "profiles" {

#   validation {
#     condition     = length(var.profiles) < 6
#     error_message = "Maximun of 5 diagnostics profiles are supported."
#   }
# }

# variable "global_settings" {
#   default = {}
# }
