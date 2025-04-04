module "avm_res_keyvault_vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.6.1"

  tenant_id           = data.azurerm_client_config.current.tenant_id
  name                = "${module.naming.key_vault.name}-vm-${random_string.this.result}"   
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name 
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location 
  network_acls = {
    default_action = "Allow"
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

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "virtual machine key vault" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "management"
      tier = "infra"   
    }
  )  
}

module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.4.0"
}

locals {
  tags = {
    scenario = "windows_w_data_disk_and_public_ip"
  }
  regions = ["southeastasia", "southeastasia"]

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

resource "random_integer" "region_index" {
  max = length(local.regions) - 1
  min = 0
}

resource "random_integer" "zone_index" {
  max = length(module.regions.regions_by_name[local.regions[random_integer.region_index.result]].zones)
  min = 1
}

resource "azurerm_user_assigned_identity" "user" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

module "virtualmachine1" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.14.0"

  enable_telemetry                       = var.enable_telemetry
  location                               = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name                    = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  virtualmachine_os_type                 = "Windows"
  name = (
    length(replace("${module.naming.virtual_machine.name}-${random_string.this.result}", "-", "")) > 15
    ? substr(replace("${module.naming.virtual_machine.name}-${random_string.this.result}", "-", ""), 0, 15)
    : replace("${module.naming.virtual_machine.name}-${random_string.this.result}", "-", "")
  )  
  admin_credential_key_vault_resource_id = module.avm_res_keyvault_vault.resource_id
  virtualmachine_sku_size                = "Standard_D8s_v3" # "Standard_D8s_v3" 
  zone                                   = random_integer.zone_index.result 

  # use source_image_resource_id for gcc, else use default source_image_reference
  source_image_reference = try(var.source_image_resource_id, null) == null ? local.source_image_reference : null

  source_image_resource_id = try(var.source_image_resource_id, null) == null ? null : var.source_image_resource_id

  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name}-ipconfig1"
          private_ip_subnet_resource_id = try(local.remote.networking.virtual_networks.spoke_management.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_management.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
          create_public_ip_address      = false # true
          public_ip_address_name        = module.naming.public_ip.name_unique
        }
      }
    }
  }

  data_disk_managed_disks = {
    disk1 = {
      name                 = "${module.naming.managed_disk.name}-lun0"
      storage_account_type = "StandardSSD_LRS"
      lun                  = 0
      caching              = "ReadWrite"
      disk_size_gb         = 32
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "virtual machine tooling server" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "management"
      tier = "infra"   
    }
  )  

  managed_identities = {
    system_assigned            = false # true
    user_assigned_resource_ids = [azurerm_user_assigned_identity.user.id]   
  }

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}

