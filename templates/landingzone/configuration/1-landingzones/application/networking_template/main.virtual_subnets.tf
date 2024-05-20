module "virtual_subnet1" {
  source = "./../../../../../../modules/networking/terraform-azurerm-subnet"

  virtual_network_name  = local.remote.networking.virtual_networks.spoke_project.virtual_network.name 
  resource_group_name   = local.remote.resource_group.name 
  subnets = local.global_settings.subnets.project # valid value from config.yaml: project, management, devops, hub_internet_ingress, hub_internet_egress, hub_intranet_ingress, hub_intranet_egress
}
