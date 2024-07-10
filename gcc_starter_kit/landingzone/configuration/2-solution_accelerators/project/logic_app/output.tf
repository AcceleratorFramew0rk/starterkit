output "resource" {
  value       = module.logicapp.resource 
  description = "The Azure logicapp resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
