module "nsg1" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.1.1"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name_unique}-app" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  nsgrules            = var.rule1
}

module "nsg2" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.1.1"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = "${module.naming.network_security_group.name_unique}-sysnode" # between 3 and 24 characters
  location            = azurerm_resource_group.this.location
  nsgrules            = var.rule2
}

variable "rule1" {
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

variable "rule2" {
  type = map(object(
    {
      # nsg_rule_name                       = string # (Required) Name of NSG rule.
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
    "AllowInboundRule02" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureLoadBalancer"
      nsg_rule_destination_port_range     = "*"
      nsg_rule_direction                  = "Inbound"
      nsg_rule_priority                   = 110
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "AzureLoadBalancer"
      nsg_rule_source_port_range          = "*"

    }
    "AllowInboundRule03" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "*"
      nsg_rule_destination_port_range     = "*"
      nsg_rule_direction                  = "Inbound"
      nsg_rule_priority                   = 120
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "GatewayManager"
      nsg_rule_source_port_range          = "65200-65535"

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
    "AllowOutboundRule02" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "MicrosoftContainerRegistry"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 110
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule03" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "MicrosoftContainerRegistry"
      nsg_rule_destination_port_range     = "53"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 120
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule04" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureFrontDoor.FirstParty"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 130
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule05" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "MicrosoftCloudAppSecurity"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 140
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule06" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureKeyVault.SouthEastAsia"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 150
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule07" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureMonitor"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 160
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule08" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureMonitor"
      nsg_rule_destination_port_range     = "1886"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 170
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule09" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureCloud.SouthEastAsia"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 180
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule10" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureCloud.SouthEastAsia"
      nsg_rule_destination_port_range     = "80"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 190
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }  
    "AllowOutboundRule11" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureCloud.SouthEastAsia"
      nsg_rule_destination_port_range     = "32526"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 200
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    } 
    "AllowOutboundRule12" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureCloud.SouthEastAsia"
      nsg_rule_destination_port_range     = "1194"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 210
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule13" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureCloud.SouthEastAsia"
      nsg_rule_destination_port_range     = "9000"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 220
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule14" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "Internet"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 230
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule15" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "Storage"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 240
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule16" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "Storage"
      nsg_rule_destination_port_range     = "445"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 250
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule17" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureResourceManager"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 260
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule18" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureActiveDirectory"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 270
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }
    "AllowOutboundRule19" = {
      nsg_rule_access                     = "Allow"
      nsg_rule_destination_address_prefix = "AzureFrontDoor.Frontend"
      nsg_rule_destination_port_range     = "443"
      nsg_rule_direction                  = "Outbound"
      nsg_rule_priority                   = 280
      nsg_rule_protocol                   = "Tcp"
      nsg_rule_source_address_prefix      = "VirtualNetwork"
      nsg_rule_source_port_range          = "*"
    }  
  }  
  description = "NSG rules to create"
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation1" {
  # count = try(module.virtual_subnet1.subnets["AppSubnet"], null) == null ? 0 : 1
  count = lookup(module.virtual_subnet1.subnets, "AppSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["AppSubnet"].id
  network_security_group_id = module.nsg1.nsg_resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg1
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsgassociation2" {
  # count = try(module.virtual_subnet1.subnets["SystemNodePoolSubnet"], null) == null ? 0 : 1
  count = lookup(module.virtual_subnet1.subnets, "SystemNodePoolSubnet", null) == null ? 0 : 1

  subnet_id                 = module.virtual_subnet1.subnets["SystemNodePoolSubnet"].id
  network_security_group_id = module.nsg2.nsg_resource.id

  depends_on = [
    module.virtual_subnet1,
    module.nsg2
  ]
}