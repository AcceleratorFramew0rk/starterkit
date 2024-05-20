output "keyvault_resource" {
  value       = module.keyvault.resource 
  description = "The Azure keyvault resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
