output "resource" {
  value       = module.virtualmachine1 
  description = "The Azure virtual machine resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
