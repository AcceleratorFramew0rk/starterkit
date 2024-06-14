resource "azurerm_mssql_server" "mssql" {
  name                          = var.name
  resource_group_name           = var.resource_group_name 
  location                      = var.location 
  version                       = try(var.mssql_version, "12.0") 
  administrator_login           = try(var.administrator_login,null) 
  administrator_login_password  = try(var.administrator_login_password,null) 
  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator == null ? [] : [1]
    content {
      azuread_authentication_only = try(var.azuread_administrator.azuread_authentication_only, false)
      login_username              = try(var.azuread_administrator.login_username, null) 
      object_id                   = try(var.azuread_administrator.object_id, null) 
      tenant_id                   = try(var.azuread_administrator.tenant_id, null) 
    }
  }
  connection_policy             = try(var.connection_policy, null) 
  dynamic "identity" {
    for_each = var.identity == null ? [] : [1]
    content {
      type = var.identity.type
      identity_ids = var.identity.identity_ids 
    }
  }
  transparent_data_encryption_key_vault_key_id = try(var.transparent_data_encryption_key_vault_key_id, null) 
  minimum_tls_version           = try(var.minimum_tls_version, null) 
  public_network_access_enabled = try(var.public_network_access_enabled, true) 
  outbound_network_restriction_enabled = try(var.outbound_network_restriction_enabled, false)   
  primary_user_assigned_identity_id = try(var.primary_user_assigned_identity_id, null)
  tags                          = var.tags
}
