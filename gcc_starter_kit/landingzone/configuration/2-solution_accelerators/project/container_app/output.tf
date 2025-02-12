# output "resource" {
#   value       = {
#     id = module.container_app1.resource.id
#     name = module.container_app1.resource.name
#   }
#   description = "The Azure containter instance resource"
# }

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}

output "private_dns_zones_resource" {
  value       = module.private_dns_zones[0].resource 
  description = "The Azure private_dns_zones resource"
  sensitive = true  
}

