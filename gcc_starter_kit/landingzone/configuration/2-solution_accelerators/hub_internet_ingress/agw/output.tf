output "resource" {
  value       = module.application_gateway.resource 
  description = "The Azure application gateway resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
