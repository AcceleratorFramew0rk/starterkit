module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  prefix                 = ["${local.config.prefix}"] 
  unique-seed            = "random"
  unique-length          = 3
  unique-include-numbers = false  
}

# This allow use to randomize the name of resources
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

# local variables
locals {
  global_settings = {
    location = local.config.location 
    default_region = "region1"
    environment = local.config.environment 
    inherit_tags = true
    passthrough = false
    prefix = local.config.prefix 
    prefix_with_hyphen = local.config.prefix 
    prefixes = [
      local.config.prefix 
    ]
    random_length = "${var.random_length}"
    regions = {
      region1 = local.config.location  
      region2 = "eastus"
    }
    tags  = var.global_tags
    use_slug = true
    # subnets cidr
    subnets = local.config.subnets
  }
} 

