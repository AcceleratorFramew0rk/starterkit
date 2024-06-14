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

variable "mssql_version" {
  description = "The version of the MSSQL Server"
  default     = "12.0"
}

variable "administrator_login" {
  description = "(Required) The Administrator Login for the MSSQL Server"
}

variable "administrator_login_password" {
  description = "(Required) The Password associated with the administrator_login for the PostgreSQL Server."
}

variable "public_network_access_enabled" {
  description = "The connection policy the server will use (Default, Proxy or Redirect)"
  default     = true
}

variable "connection_policy" {
  description = "The connection policy the server will use (Default, Proxy or Redirect)"
  default     = "Default"
}


variable "minimum_tls_version" {
  description = "Specifies the minimum tls version"
  default     = "1.2"
}

variable "azuread_administrator" {
  description = "Specifies the azuread administrator"
  default     = null
}

variable "identity" {
  description = "Specifies the identity"
   default     = null
}

variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default     = {}
}

variable "transparent_data_encryption_key_vault_key_id" {
  description = "Specifies the transparent_data_encryption_key_vault_key_id"
  default     = null
}

variable "primary_user_assigned_identity_id" {
  description = "Specifies the primary_user_assigned_identity_id"
  default     = null
}

variable "outbound_network_restriction_enabled" {
  description = "Specifies the outbound_network_restriction_enabled"
  default     = null
}
