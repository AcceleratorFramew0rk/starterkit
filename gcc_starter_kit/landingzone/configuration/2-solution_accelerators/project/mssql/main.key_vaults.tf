module "keyvault" {
  # grant spn to be secret reader  
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.5.2"  

  enable_telemetry              = var.enable_telemetry
  location                        = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                            = "${module.naming.key_vault.name}-mssql-${random_string.this.result}" 
  resource_group_name             = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  sku_name                        = "standard"  
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  # enable_rbac_authorization       = true
  enabled_for_deployment          = false 
  enabled_for_disk_encryption     = true 
  enabled_for_template_deployment = false 
  public_network_access_enabled   = true 
  purge_protection_enabled        = false 
  soft_delete_retention_days      = 7

  secrets = {
    sql_admin_password = {
      name = "sqladminpassword"
    }
  }
  secrets_value = { 
    sql_admin_password = random_password.sql_admin.result
  }

  network_acls = {
    bypass = "AzureServices" # The bypass value must be either `AzureServices` or `None`.
    ip_rules = ["0.0.0.0/0"] # TODO: how to set this.
  }

  role_assignments = {
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }

}

# Generate sql server random admin password if not provided in the attribute administrator_login_password
resource "random_password" "sql_admin" {
  length           = 128
  special          = true
  upper            = true
  numeric          = true
  override_special = "$#%"
}

