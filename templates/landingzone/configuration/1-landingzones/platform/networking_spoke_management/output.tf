output "virtual_subnets" {
  value       = module.virtual_subnet1
  description = "The Azure Virtual Subnets resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
