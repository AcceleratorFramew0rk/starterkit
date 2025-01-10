
# keyvault
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-keyvault.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# app service
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# mssql
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/mssql

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-mssql.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"


# storage account
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-storageaccount.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# apim
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/apim

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-apim.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"


# linux function app
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/linux_function_app

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-linuxfunctionapp.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"


# iot hub
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/iot_hub

terraform init  -reconfigure \
-backend-config="resource_group_name=uatlite-rg-launchpad" \
-backend-config="storage_account_name=uatlitestgtfstate3a9" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-iothub.tfstate"

terraform plan \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

# event hubs
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/event_hubs

terraform init  -reconfigure \
-backend-config="resource_group_name=uatlite-rg-launchpad" \
-backend-config="storage_account_name=uatlitestgtfstate3a9" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-eventhubs.tfstate"

terraform plan \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"



# data explorer
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/data_explorer

terraform init  -reconfigure \
-backend-config="resource_group_name=uatlite-rg-launchpad" \
-backend-config="storage_account_name=uatlitestgtfstate3a9" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-dataexplorer.tfstate"


terraform plan \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"



# vm for vnet data gateway (to be confirmed)
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/vm

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-vm.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"



# stream analytics (must be last solution accelerator to be deployed)
# ** IMPORTANT: This step requires event hubs, iot hub, data explorer and sql server to be deployed first
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/stream_analytics

terraform init  -reconfigure \
-backend-config="resource_group_name=uatlite-rg-launchpad" \
-backend-config="storage_account_name=uatlitestgtfstate3a9" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-streamanalytics.tfstate"

terraform plan \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

# # Approved via Azure CLI
# az network private-endpoint-connection approve \
#   --id /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Devices/IotHubs/{iot-hub-name}/privateEndpointConnections/{private-connection-name} \
#   --description "Approving private endpoint for Stream Analytics"

