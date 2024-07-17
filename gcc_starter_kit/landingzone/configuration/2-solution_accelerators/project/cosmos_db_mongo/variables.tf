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

variable "cosmos_api" {}
variable "sql_dbs" {}
variable "sql_db_containers" {}

# variable "mongo_dbs" {}
# variable "mongo_db_collections" {}


/* Mongo API Variables*/
variable "mongo_dbs" {
  type = map(object({
    db_name           = string
    db_throughput     = number
    db_max_throughput = number
  }))
  description = "Map of Cosmos DB Mongo DBs to create. Some parameters are inherited from cosmos account."
  default     = {
    cosmosdb1 = {
      db_name           = "cosmosdb-mongo-db"
      db_throughput     = 100
      db_max_throughput = 1000
    }
  }
}

variable "mongo_db_collections" {
  type = map(object({
    collection_name           = string
    db_name                   = string
    default_ttl_seconds       = string
    shard_key                 = string
    collection_throughout     = number
    collection_max_throughput = number
    analytical_storage_ttl    = number
    indexes = map(object({
      mongo_index_keys   = list(string)
      mongo_index_unique = bool
    }))
  }))
  description = "List of Cosmos DB Mongo collections to create. Some parameters are inherited from cosmos account."
  default     = {
    mongodbcollections1 = {
      collection_name     = "tfex-cosmos-mongo-db"
      db_name             = "cosmosdb-mongo-db"
      default_ttl_seconds = "777"
      shard_key           = "uniqueKey"
      collection_throughout     = 100
      collection_max_throughput = 1000
      analytical_storage_ttl    = null    
      indexes = {
        index1 = {
          mongo_index_keys   = ["_id"]
          mongo_index_unique = true
        }
      }
    }
  }
}


  # for_each            = var.mongo_dbs
  # for_each               = var.mongo_db_collections  

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