output "resource" {
  value       = module.redis_cache.resource 
  description = "The Azure redis_cache resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
