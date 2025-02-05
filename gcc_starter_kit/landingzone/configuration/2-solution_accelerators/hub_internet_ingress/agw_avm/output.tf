output "resource" {
  value       = {
    id = module.application_gateway.application_gateway_id
    name = module.application_gateway.application_gateway_name
  }

  description = "The Azure application gateway resource"
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}
