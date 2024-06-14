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

variable "server_name" {
  description = "The name of MSSQL Server"
  default     = "12.0"
}

variable "max_size_gb" {
  description = "Specify max size gb"
  default     = "756"
}

variable "max_size_bytes" {
  description = "Specify max size bytes"
  default     = null 
}

variable "zone_redundant" {
  description = "Specify zone redundant - tier needs to be Premium for DTU based or BusinessCritical for vCore based sku"
  default     = false
}

variable "license_type" {
  description = "Specify License Type"
  default     = "LicenseIncluded"
}

variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default     = {}
}

variable "sku" {
  description = "Specifies the tags"
  type        = map(any)
  default     = {}
}

variable "per_database_settings" {
  description = "Specifies the tags"
  type        = map(any)
  default     = {}
}

variable "maintenance_configuration_name" {
  description = "Specify maintenance configuration name"
  default     = null 
}

variable "enclave_type" {
  description = "Specify enclave type"
  default     = null 
}
