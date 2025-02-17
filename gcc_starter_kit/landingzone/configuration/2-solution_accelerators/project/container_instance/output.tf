output "resource" {
  value       = module.container_group1 
  description = "The Azure containter instance resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
