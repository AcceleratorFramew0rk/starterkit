output "mssql_server_resource" {
  value       = module.sql_server.resource 
  description = "The Azure mssql_server_resource resource"
  sensitive = true  
}

output "mssql_database_resource" {
  value       = module.sql_server.resource_databases 
  description = "The Azure mssql_database_resource resource"
  sensitive = true  
}

output "mssql_elastic_pool_resource" {
  value       = module.sql_server.resource_elasticpools 
  description = "The Azure mssql_elastic_pool_resource resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
