output "resource" {
  value       = module.storageaccount.resource 
  description = "The Azure storageaccount resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
