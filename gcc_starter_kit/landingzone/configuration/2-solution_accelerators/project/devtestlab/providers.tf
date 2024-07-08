# terraform {
#   required_version = ">=0.12"
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~>2.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "~>3.0"
#     }
#   }
# }

# Configure Terraform backend
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }    
  }
}

provider "azurerm" {
  features {}
}