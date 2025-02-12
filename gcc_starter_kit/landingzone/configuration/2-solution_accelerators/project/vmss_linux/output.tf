output "resource" {
  value       = module.vmss
  description = "The Azure virtual machine scale set resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
