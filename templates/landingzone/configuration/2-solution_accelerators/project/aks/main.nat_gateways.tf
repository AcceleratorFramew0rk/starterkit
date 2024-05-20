module "natgateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"

  name                = "${module.naming.nat_gateway.name}-${random_string.this.result}"
  enable_telemetry    = true
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

}

module "subnet_nat_gateway_association" {
  source     = "./../../../../../../modules/networking/terraform-azurerm-subnetnatgatewayassociation"  

  nat_gateway_id                = module.natgateway.resource.id
  subnet_ids          = {
      subnet_id2 = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["SystemNodePoolSubnet"].id
      subnet_id3 = local.remote.networking.virtual_networks.spoke_project.virtual_subnets.subnets["UserNodePoolSubnet"].id
    }  
}

module "public_ip1" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.public_ip.name_unique}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location 
  sku = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gategay_public_ip_association" {
  nat_gateway_id       = module.natgateway.resource.id
  public_ip_address_id = module.public_ip1.public_ip_id
}
