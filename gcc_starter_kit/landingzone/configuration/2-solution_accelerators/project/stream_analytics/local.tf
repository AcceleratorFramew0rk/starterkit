# # read current level terraform state - sqlserver
data "terraform_remote_state" "sqlserver" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "2-solution-accelerators"
    key                  = "solution_accelerators-project-mssql.tfstate" 
  }
}

# read current level terraform state - data explorer
data "terraform_remote_state" "dataexplorer" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "2-solution-accelerators"
    key                  = "solution_accelerators-project-dataexplorer.tfstate" 
  }
}

# read current level terraform state - data explorer
data "terraform_remote_state" "eventhubs" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "2-solution-accelerators"
    key                  = "solution_accelerators-project-eventhubs.tfstate" 
  }
}

# read current level terraform state - iot hub
data "terraform_remote_state" "iothub" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = "2-solution-accelerators"
    key                  = "solution_accelerators-project-iothub.tfstate" 
  }
}

locals {
  sqlserver = try(data.terraform_remote_state.sqlserver.outputs.mssql_server_resource, null)     
  dataexplorer = try(data.terraform_remote_state.dataexplorer.outputs.resource, null)     
  eventhubs = try(data.terraform_remote_state.eventhubs.outputs.resource, null)     
  iothub = try(data.terraform_remote_state.iothub.outputs.resource, null)     
  # Check Resource Type: Ensure that the resource type is correctly specified. It should be Microsoft.Devices/IotHubs (case-sensitive).
  iothub_id = try(data.terraform_remote_state.iothub.outputs.resource.resource.id, null) == null ? null : replace(try(data.terraform_remote_state.iothub.outputs.resource.resource.id, null) , "iotHubs", "IotHubs")
  eventhub_namespace_id  = try(data.terraform_remote_state.eventhubs.outputs.eventhub_namespace_id, null)     
}

