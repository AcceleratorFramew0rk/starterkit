variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  type        = string
  description = "location"
  default     = "southeastasia"
}

variable "capacity" { default = null }
variable "family" { default = null }
variable "sku_name" { default = null }
variable "tags" { default = null }

variable "enable_non_ssl_port" { default = null }
variable "minimum_tls_version" { default = null }
variable "private_static_ip_address" { default = null }
variable "public_network_access_enabled" { default = null }
variable "shard_count" { default = null }
variable "replicas_per_master" { default = null }
variable "replicas_per_primary" { default = null }
variable "zones" { default = null }
variable "redis_version" { default = null }
variable "subnet_id" { default = null }

variable "redis_configuration" { default = null }
variable "identity" { default = null }
variable "patch_schedule" { default = null }