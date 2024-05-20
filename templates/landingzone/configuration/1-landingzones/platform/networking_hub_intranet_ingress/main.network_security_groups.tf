module "nsg1" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.1.1"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name_unique}-agw"
  location            = local.global_settings.location
  nsgrules            = var.rules_agwsubnet
}

variable "rules_agwsubnet" {
  type = map(object(
    {
      nsg_rule_priority                   = number # (Required) NSG rule priority.
      nsg_rule_direction                  = string # (Required) NSG rule direction. Possible values are `Inbound` and `Outbound`.
      nsg_rule_access                     = string # (Required) NSG rule access. Possible values are `Allow` and `Deny`.
      nsg_rule_protocol                   = string # (Required) NSG rule protocol. Possible values are `Tcp`, `Udp`, `Icmp`, `Esp`, `Asterisk`.
      nsg_rule_source_port_range          = string # (Required) NSG rule source port range.
      nsg_rule_destination_port_range     = string # (Required) NSG rule destination port range.
      nsg_rule_source_address_prefix      = string # (Required) NSG rule source address prefix.
      nsg_rule_destination_address_prefix = string # (Required) NSG rule destination address prefix.
    }
  ))
  default = {
    # inbound rules
    "AllowInboundRule01" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "*"
      nsg_rule_destination_port_range     = "*"
      nsg_rule_direction                  = "Inbound"
      nsg_rule_priority                   = 100
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "*"
      nsg_rule_source_port_range          = "*"

    }
    # outbound rules
    "AllowOutboundRule01" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "*"
      nsg_rule_destination_port_range     = "*"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 100
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "*"
      nsg_rule_source_port_range          = "*"

    }
  }
  description = "NSG rules to create"
}

resource "azurerm_subnet_network_security_group_association" "AgwSubnet1" {
  count = lookup(module.virtual_subnet1.subnets, "AgwSubnet", null) == null ? 0 : 1
    
  subnet_id                 = module.virtual_subnet1.subnets["AgwSubnet"].id
  network_security_group_id = module.nsg1.nsg_resource.id

  depends_on = [
    module.virtual_subnet1,
    # module.virtual_subnet2,
    module.nsg1
  ]
}
