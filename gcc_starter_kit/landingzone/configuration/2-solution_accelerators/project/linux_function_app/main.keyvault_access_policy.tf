resource "azurerm_key_vault_access_policy" "function_app" {

  count = try(local.keyvault.id, null) != null ? 1 : 0   

  key_vault_id = local.keyvault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  # object_id = module.linux_function_app.identity_principal_id # resource.identity[0].principal_id 
  object_id = module.linux_function_app.resource.identity[0].principal_id
  # object_id = module.linux_function_app.system_assigned_mi_principal_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Recover",
    "Restore",
    "Set",
    "Purge"
  ]
  key_permissions         = []
  certificate_permissions = []
  storage_permissions     = []

  depends_on = [module.linux_function_app]
}

# resource "azurerm_key_vault_access_policy" "current_user" {

#   count = try(local.keyvault.id, null) != null ? 1 : 0   

#   key_vault_id = local.keyvault.id 
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = data.azurerm_client_config.current.object_id

#   secret_permissions = [
#     "Backup",
#     "Delete",
#     "Get",
#     "List",
#     "Recover",
#     "Restore",
#     "Set",
#     "Purge"
#   ]
#   key_permissions         = []
#   certificate_permissions = []
#   storage_permissions     = []

#   depends_on = [module.linux_function_app]  
# }


# resource "azurerm_key_vault_secret" "storage_account_connection_string_secret" {
#   name         = var.storage_account_connection_string_secret_name
#   value        = azurerm_storage_account.main.primary_connection_string
#   key_vault_id = azurerm_key_vault.main.id
#   depends_on = [
#     azurerm_key_vault_access_policy.current_user
#   ]
# }

# resource "azurerm_key_vault_secret" "storage_container_secret" {
#   name         = var.storage_container_secret_name
#   value        = var.storage_container_name
#   key_vault_id = azurerm_key_vault.main.id
#   depends_on = [
#     azurerm_key_vault_access_policy.current_user
#   ]
# }