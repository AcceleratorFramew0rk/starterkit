output "resource" {
  value       = {
    id = module.container_group1.resource_id
    name = module.container_group1.name
  }
  description = "The Azure containter instance resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
