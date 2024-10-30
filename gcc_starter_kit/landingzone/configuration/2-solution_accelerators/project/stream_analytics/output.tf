output "resource" {
  value       = module.stream_analytics
  description = "The Azure stream_analytics resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}

