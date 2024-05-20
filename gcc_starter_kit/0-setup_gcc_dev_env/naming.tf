module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
  prefix                 = ["${var.name_prefix}"] # ["${var.name_prefix}", "fix"]
  unique-seed            = "random"
  unique-length          = 3
  unique-include-numbers = false  
}

