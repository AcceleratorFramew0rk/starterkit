module "virtual_subnet1" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-subnet"

  virtual_network_name  = local.remote.networking.virtual_networks.spoke_project.virtual_network.name 
  resource_group_name   = local.remote.resource_group.name 
  subnets = local.global_settings.subnets.project
}
