provider "azurerm" {
  features {}
}

# Configure Terraform backend
terraform {
  required_version = ">= 1.0.0"
  # required_version = "~> 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
  }
  backend "azurerm" {}
}
