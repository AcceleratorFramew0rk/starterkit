module "firewall_policy" {
  source              = "Azure/avm-res-network-firewallpolicy/azurerm"

  enable_telemetry    = var.enable_telemetry
  name                = module.naming.firewall_policy.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  firewall_policy_sku = "Premium" # "Basic" # both firewall and firewall policy must in same tier
}


resource "azurerm_firewall_nat_rule_collection" "natcollection" {

  name                = module.naming.firewall_nat_rule_collection.name_unique
  azure_firewall_name = module.firewall.firewall_resource.name 
  resource_group_name = azurerm_resource_group.this.name 
  priority            = 100
  action              = "Dnat"
  rule {
    name = "ingress_rule"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "443",
    ]
    destination_addresses = [
      module.public_ip_firewall1.public_ip_id 
    ]
    translated_port = 443 
    translated_address = try(cidrhost(local.global_settings.subnets.hub_internet_ingress.AgwSubnet.address_prefixes.0, 10), null)  # (agw subnet cidr 100.127.0.64/27, offset 10) >"100.127.0.74" 
    protocols = [
      "TCP",
    ]
  }

}
