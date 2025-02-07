# add your solution accelerator terraform here.
resource "azurerm_user_assigned_identity" "this" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                = "${module.naming.user_assigned_identity.name}-${random_string.this.result}"  # "uami-${random_id.name.hex}"
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
}

module "apim" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/apim/api_management"
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/apim/api_management" 

  name                         = "${module.naming.api_management.name}-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  publisher_name       = "My Company"
  publisher_email      = "company@terraform.io"
  sku_name             = try(local.global_settings.environment, var.environment) != "Production" ? "Developer_1" : "Premium"

  identity = {
    type = "UserAssigned"
    identity_ids        = [azurerm_user_assigned_identity.this.id]    
  }   

  virtual_network_type = "Internal"
  virtual_network_configuration = {
    subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ApiSubnet"].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets["ApiSubnet"].resource.id : var.subnet_id 
  }

  tags                = merge(
    local.global_settings.tags,
    {
      purpose = "api management" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
    
}

