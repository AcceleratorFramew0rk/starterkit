module "virtual_subnet1" {
  source = "./../../../../../../modules/networking/terraform-azurerm-subnet"

  virtual_network_name  = local.remote.networking.virtual_networks.spoke_management.virtual_network.name 
  resource_group_name   = local.remote.resource_group.name 
  subnets = local.global_settings.subnets.management
}
