module "avm_res_keyvault_vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = ">= 0.5.0"

  tenant_id           = data.azurerm_client_config.current.tenant_id
  name                = "${module.naming.key_vault.name}${random_string.this.result}"  
  resource_group_name = azurerm_resource_group.this.name 
  location            = azurerm_resource_group.this.location 
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

  tags = local.tags
}

module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.4.0"
}

locals {
  tags = {
    scenario = "windows_w_data_disk_and_public_ip"
  }
  test_regions = ["southeastasia", "southeastasia"]
  # test_regions = ["centralus", "eastasia", "westus2", "eastus2", "westeurope", "japaneast"]
}

resource "random_integer" "region_index" {
  max = length(local.test_regions) - 1
  min = 0
}

resource "random_integer" "zone_index" {
  max = length(module.regions.regions_by_name[local.test_regions[random_integer.region_index.result]].zones)
  min = 1
}

module "virtualmachine1" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.1.0"

  enable_telemetry                       = var.enable_telemetry
  location                               = azurerm_resource_group.this.location
  resource_group_name                    = azurerm_resource_group.this.name
  virtualmachine_os_type                 = "Windows"
  name                                   = "${module.naming.virtual_machine.name}${random_string.this.result}" 
  admin_credential_key_vault_resource_id = module.avm_res_keyvault_vault.resource.id
  virtualmachine_sku_size                = "Standard_D8s_v3" # "standard_d2_v2" "Standard_D8s_v3" 
  zone                                   = random_integer.zone_index.result 

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name}-ipconfig1"
          private_ip_subnet_resource_id = local.remote.networking.virtual_networks.spoke_management.virtual_subnets.subnets["InfraSubnet"].id 
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

  tags = { 
    purpose = "tooling server" 
    project_code = local.global_settings.prefix 
    env = local.global_settings.environment 
    zone = "management"
    tier = "na"          
  }   

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}


      # - identity {
      #     - identity_ids = [
      #         - "/subscriptions/0b5b13b8-0ad7-4552-936f-8fae87e0633f/resourceGroups/Built-In-Identity-RG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/Built-In-Identity-southeastasia",
      #       ] -> null
      #     - type         = "UserAssigned" -> null
      #   }