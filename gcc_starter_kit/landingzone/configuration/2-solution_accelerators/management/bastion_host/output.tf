output "azure_bastion_resource" {
  value       = {
    id = module.azure_bastion.bastion_resource.id
    name = module.azure_bastion.bastion_resource.name
  }
  description = "The Azure containter instance resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
