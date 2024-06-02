output "firewall_resource" {
  value       = {
    id = module.firewall.resource.id
    name = module.firewall.resource.name
  } 
  description = "The Azure firewall resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
