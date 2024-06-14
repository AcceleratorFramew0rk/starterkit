
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  for_each              = var.subnet_ids
  subnet_id             = each.value
  nat_gateway_id        = var.nat_gateway_id
}