output "resource" {
  value       = module.data_explorer 
  description = "The Azure stream_analyticss resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
