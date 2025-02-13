variable "dns_zone_group_name" {
  type        = string
  description = "Zone Group Name for PE"
  default     = "pe_zone_group"
}

variable "pe_name" {
  type        = string
  description = "Private Endpoint Name"
  default     = "cosmosdb_pe"
}

variable "pe_connection_name" {
  type        = string
  description = "Private Endpoint Connection Name"
  default     = "pe_connection"
}

variable "cosmos_api" {
  default = "sql"
}

/* SQL API Variables*/
variable "sql_dbs" {
  type = map(object({
    db_name           = string
    db_throughput     = number
    db_max_throughput = number
  }))
  description = "Map of Cosmos DB SQL DBs to create. Some parameters are inherited from cosmos account."
  default     = {
    cosmosdb1 = {
      db_name           = "cosmosdb-sql-db"
      db_throughput     = 100
      db_max_throughput = 1000
    }
  }
}

variable "sql_db_containers" {
  type = map(object({
    container_name           = string
    db_name                  = string
    partition_key_path       = string
    partition_key_version    = number
    container_throughout     = number
    container_max_throughput = number
    default_ttl              = number
    analytical_storage_ttl   = number
    indexing_policy_settings = object({
      sql_indexing_mode = string
      sql_included_path = string
      sql_excluded_path = string
      composite_indexes = map(object({
        indexes = set(object({
          path  = string
          order = string
        }))
      }))
      spatial_indexes = map(object({
        path = string
      }))
    })
    sql_unique_key = list(string)
    conflict_resolution_policy = object({
      mode      = string
      path      = string
      procedure = string
    })
  }))
  description = "List of Cosmos DB SQL Containers to create. Some parameters are inherited from cosmos account."
  default = null
  # default     = {


  #   container_name                  = "example-container"
  #   db_name         = azurerm_cosmosdb_sql_database.example.name
  #   partition_key_path    = "/definition/id"
  #   partition_key_version = 1
  #   throughput            = 400

  #   indexing_policy {
  #     indexing_mode = "consistent"

  #     included_path {
  #       path = "/*"
  #     }

  #     included_path {
  #       path = "/included/?"
  #     }

  #     excluded_path {
  #       path = "/excluded/?"
  #     }
  #   }

  #   unique_key {
  #     paths = ["/definition/idlong", "/definition/idshort"]
  #   }

  # }

}

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

variable "vnet_name" {
  type        = string  
  default = "null"
}

variable "vnet_resource_group_name" {
  type        = string  
  default = "gcci-platform"
}

variable "subnet_name" {
  type        = string  
  default = "CosmosDbSubnet"
}