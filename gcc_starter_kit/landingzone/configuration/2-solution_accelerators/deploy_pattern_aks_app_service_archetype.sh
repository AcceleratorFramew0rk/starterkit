#!/bin/bash

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

# -----------------------------------------------------------------------------------------------------
# keyvault - ServiceSubnet - is the first resource to be deployed in the solution accelerators. 
# -----------------------------------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------------------------------
# acr - ServiceSubnet 
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-acr.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# -----------------------------------------------------------------------------------------------------
# aks private cluster - will reference the acr above to assign acrpull role to the aks service principal
# -----------------------------------------------------------------------------------------------------
# SystemNodeSubnet, UserNodeSubnet, UserNodeIntranetSubnet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-aks.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# -----------------------------------------------------------------------------------------------------
# mssql - DbSubnet 
# -----------------------------------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------------------------------
# redis cache - DbSubnet
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/redis_cache

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-rediscache.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"


# -----------------------------------------------------------------------------------------------------
# app service - ServiceSubnet (Inbound) + AppServiceSubnet (VNet Integration) 
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service_windows

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" 
# \
# -var="windows_fx_version=DOTNETCORE|8.0" \
# -var="kind=Windows" 


terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" 
# \
# -var="windows_fx_version=DOTNETCORE|8.0"\
# -var="kind=Windows" 

# -----------------------------------------------------------------------------------------------------
# storage account
# -----------------------------------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------------------------------
# vm - ai - AiSubnet - windows server 2022 server
# -----------------------------------------------------------------------------------------------------
# default is deploy to AppSubnet, change the subnet_id to AiSubnet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/vm

# ** IMPORTANT - define subnet_id for the VM deployment
VNET_NAME=$(yq  -r '.vnets.project.name' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
echo $VNET_NAME
SUBNET_NAME="AiSubnet"
SUBSCRIPTION_ID=$(echo "$(az account show 2> /dev/null)" | jq ".id" -r)
echo $SUBSCRIPTION_ID
SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${SUBNET_NAME}"
echo $SUBNET_ID


terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-vm-windows.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="subnet_id=${SUBNET_ID}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="subnet_id=${SUBNET_ID}"


# -----------------------------------------------------------------------------------------------------
# vm - oss - AiSubnet - linux OS - Ubuntu
# -----------------------------------------------------------------------------------------------------
# default is deploy to AppSubnet, change the subnet_id to AiSubnet
# virtualmachine_os_type is default to Windows, set this to Linux
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/vm

# ** IMPORTANT - define subnet_id for the VM deployment
VNET_NAME=$(yq  -r '.vnets.project.name' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)

SUBNET_NAME="AiSubnet"
SUBSCRIPTION_ID=$(echo "$(az account show 2> /dev/null)" | jq ".id" -r)
echo $SUBSCRIPTION_ID
SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${SUBNET_NAME}"
echo $SUBNET_ID


terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-vm-linux.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="subnet_id=${SUBNET_ID}" \
-var="virtualmachine_os_type=Linux" 

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="subnet_id=${SUBNET_ID}" \
-var="virtualmachine_os_type=Linux" 
