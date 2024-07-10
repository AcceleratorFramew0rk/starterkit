output "resource" {
  value       = module.azureopenai.resource 
  description = "The Azure azure openai resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
