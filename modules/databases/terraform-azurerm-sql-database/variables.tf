variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "auto_pause_delay_in_minutes" {
  type        = string
  default = null
}  
variable "collation" {
  type        = string
  default = null
}  
variable "create_mode" {
  type        = string
  default = null
}  
variable "creation_source_database_id" {
  type        = string
  default = null
}  
variable "elastic_pool_id" {
  type        = string
  default = null
}  
variable "geo_backup_enabled" {
  type        = string
  default = null
}  
variable "ledger_enabled" {
  type        = string
  default = null
}  
variable "license_type" {
  type        = string
  default = null
}  
variable "max_size_gb" {
  type        = string
  default = null
}  
variable "min_capacity" {
  type        = string
  default = null

}  
variable "read_replica_count" {
  type        = string
  default = null
}  
variable "read_scale" {
  type        = string
  default = null
}  
variable "recover_database_id" {
  type        = string
  default = null
}  
variable "restore_dropped_database_id" {
  type        = string
  default = null
}  
variable "restore_point_in_time" {
  type        = string
  default = null
}  
variable "sample_name" {
  type        = string
  default = null
}  
variable "server_id" {
  type        = string
  default = null
}  
variable "sku_name" {
  type        = string
  default = null
}  
variable "storage_account_type" {
  type        = string
  default = null
}   
variable "transparent_data_encryption_enabled" {
  type        = bool
  default = null
}  
variable "tags" {
  description = "Specifies the tags"
  type        = map(any)
  default     = {}
}  
variable "zone_redundant" {
  type        = string
  default = null
}    

variable "enclave_type" {
  type        = string
  default = null
}  

variable "threat_detection_policy" {
  default = null
}
variable "short_term_retention_policy" {
  default = null
}
variable "long_term_retention_policy" {
  default = null
}
variable "storage_accounts" {
  default = null
}

variable "import" {
  default = null
}

variable "maintenance_configuration_name" {
  default = null
}

variable "recovery_point_id" {
  default = null
}

variable "restore_long_term_retention_backup_id" {
  default = null
}

variable "identity" {
  default = null
}

variable "transparent_data_encryption_key_vault_key_id" {
  default = null
}

variable "transparent_data_encryption_key_automatic_rotation_enabled" {
  default = null
}



