output "resource" {
  value       = {
    id = module.virtualmachine1.virtual_machine.id
    name = module.virtualmachine1.virtual_machine.name
  }
  description = "The Azure virtual machine resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
