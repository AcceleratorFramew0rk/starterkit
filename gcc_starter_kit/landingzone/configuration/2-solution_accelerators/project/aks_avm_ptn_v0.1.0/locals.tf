# read current level terraform state - appservice
data "terraform_remote_state" "container_registry" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "2-solution-accelerators"
    key                  = "solution_accelerators-project-acr.tfstate" 
  }
}


locals {
  container_registry = try(data.terraform_remote_state.container_registry.outputs.resource, null)     
}

