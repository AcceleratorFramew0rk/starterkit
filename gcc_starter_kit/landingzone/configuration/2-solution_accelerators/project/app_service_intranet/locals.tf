# read current level terraform state - appservice
data "terraform_remote_state" "appservice" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "2-solution-accelerators"
    key                  = "solution_accelerators-project-appservice.tfstate" 
  }
}


locals {
  appservice = try(data.terraform_remote_state.appservice.outputs.resource, null)    
  privatednszone = try(data.terraform_remote_state.appservice.outputs.private_dns_zones_resource, null)   
}

# -----------------------------------------------------------------------------
# sample: reading tfstate from another subscription
# -----------------------------------------------------------------------------
# backend "azurerm" {
#     resource_group_name  = "resourcegroup_name"  
#     storage_account_name = "storageaccount_name" 
#     container_name       = "mystate"
#     key                  = "tfstatename1.tfstate"
#     subscription_id      = "xxxxxxxxxx-0de3-4fef-831a-xxxxxxxxxxxx"
# }