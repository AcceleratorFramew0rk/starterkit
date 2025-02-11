#!/bin/bash

source "./utils.sh"

# #------------------------------------------------------------------------
# # get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------
PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX//-/}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
if [[ -z "$STG_NAME" ]]; then
    echo "No storage account found matching the prefix."
    exit
else
    ACCOUNT_INFO=$(az account show 2> /dev/null)
    if [[ $? -ne 0 ]]; then
        echo "no subscription"
        exit
    fi
    SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
    SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
    USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)
    SUBSCRIPTION_ID="${SUB_ID}" 
fi

echo "PREFIX: ${PREFIX}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"

RESOURCE_GROUP_NAME=$(yq  -r '.resource_group_name' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)

#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------

# keyvault
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-keyvault.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# # app service
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

# terraform init  -reconfigure \
# -backend-config="resource_group_name=${RG_NAME}" \
# -backend-config="storage_account_name=${STG_NAME}" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-appservice.tfstate"

# terraform plan \
# -var="storage_account_name=${STG_NAME}" \
# -var="resource_group_name=${RG_NAME}"

# terraform apply -auto-approve \
# -var="storage_account_name=${STG_NAME}" \
# -var="resource_group_name=${RG_NAME}"

# container app
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/container_app

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-containerapp.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# mssql
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/mssql

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-mssql.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"


# storage account
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-storageaccount.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# apim
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/apim

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-apim.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"


# # linux function app
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/linux_function_app

# terraform init  -reconfigure \
# -backend-config="resource_group_name=${RG_NAME}" \
# -backend-config="storage_account_name=${STG_NAME}" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-linuxfunctionapp.tfstate"

# terraform plan \
# -var="storage_account_name=${STG_NAME}" \
# -var="resource_group_name=${RG_NAME}"

# terraform apply -auto-approve \
# -var="storage_account_name=${STG_NAME}" \
# -var="resource_group_name=${RG_NAME}"


# iot hub
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/iot_hub

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-iothub.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# # event hubs
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/event_hubs

# terraform init  -reconfigure \
# -backend-config="resource_group_name=${RG_NAME}" \
# -backend-config="storage_account_name=${STG_NAME}" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-eventhubs.tfstate"

# terraform plan \
# -var="storage_account_name=${STG_NAME}" \
# -var="resource_group_name=${RG_NAME}"

# terraform apply -auto-approve \
# -var="storage_account_name=${STG_NAME}" \
# -var="resource_group_name=${RG_NAME}"



# data explorer
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/data_explorer

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-dataexplorer.tfstate"


terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"



# vm for vnet data gateway (to be confirmed)
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/vm

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-vm.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"



# stream analytics (must be last solution accelerator to be deployed)
# ** IMPORTANT: This step requires event hubs, iot hub, data explorer and sql server to be deployed first
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/stream_analytics

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-streamanalytics.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"



# # # Approved managed endpoint via Azure CLI
# -----------------------------------------------
# execute approve managed endpoint - function in utils.sh
exec_approve_stream_analytics_managed_private_endpoint