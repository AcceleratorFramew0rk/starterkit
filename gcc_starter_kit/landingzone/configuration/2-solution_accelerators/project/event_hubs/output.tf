output "resource" {
  value       = module.event_hubs
  description = "The Azure iot_hubs resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
