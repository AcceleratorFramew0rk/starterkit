output "resource" {
  value       = module.servicebus.resource 
  description = "The Azure service bus resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
