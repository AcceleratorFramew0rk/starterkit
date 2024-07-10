output "resource" {
  value       = module.linux_function_app.resource 
  description = "The Azure linux_function_app resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
