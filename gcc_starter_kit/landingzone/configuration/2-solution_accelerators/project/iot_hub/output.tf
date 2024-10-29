output "resource" {
  value       = module.iot_hub
  description = "The Azure iot_hubs resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
