provider "azurerm" {
  features {}

  subscription_id = "0b5b13b8-0ad7-4552-936f-8fae87e0633f"
}

# Configure Terraform backend
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.11.0"
      # version = ">= 3.7.0, < 4.11.0"
      # version = ">= 3.7.0, < 4.0.0"
      
    }
  }
  backend "azurerm" {}
}


# provider "azurerm" {
#   features {}

#   subscription_id = "your-azure-subscription-id"
#   tenant_id       = "your-tenant-id"
#   client_id       = "your-client-id"
#   client_secret   = "your-client-secret"
# }