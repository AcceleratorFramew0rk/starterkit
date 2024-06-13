output "resource" {
  value       = {
    id = module.azure_bastion.resource.id
    name = module.azure_bastion.resource.name
  }
  description = "The Azure bastion host resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
