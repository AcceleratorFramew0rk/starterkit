# add your solution accelerator terraform here.
resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = "${module.naming.user_assigned_identity.name}-${random_string.this.result}"  # "uami-${random_id.name.hex}"
  resource_group_name = azurerm_resource_group.this.name
}

module "apim" {
  source = "./../../../../../../modules/apim/api_management"

  name                         = "${module.naming.api_management.name}-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location

  publisher_name       = "My Company"
  publisher_email      = "company@terraform.io"
  sku_name             = "Developer_1"


  identity = {
    type = "UserAssigned"
    identity_ids        = [azurerm_user_assigned_identity.this.id]    
  }   

  virtual_network_type = "Internal"
  virtual_network_configuration = {
    subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ApiSubnet"].id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["ApiSubnet"].id : var.subnet_id 
  }

  tags = { 
    purpose = "api management" 
    project_code = try(local.global_settings.prefix, var.prefix) 
    env = try(local.global_settings.environment, var.environment) 
    zone = "project"
    tier = "api"           
  }     
}

