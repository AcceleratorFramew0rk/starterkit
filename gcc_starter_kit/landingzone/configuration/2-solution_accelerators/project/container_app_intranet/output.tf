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
