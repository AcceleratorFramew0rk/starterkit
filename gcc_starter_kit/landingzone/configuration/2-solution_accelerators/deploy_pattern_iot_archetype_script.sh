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
# -----------------------------------------------
section="project"
key="keyvault"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# app_service
# -----------------------------------------------
section="project"
key="app_service"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# mssql
# -----------------------------------------------
section="project"
key="mssql"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# storage_account
# -----------------------------------------------
section="project"
key="storage_account"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# apim
# -----------------------------------------------
section="project"
key="apim"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 

# linux_function_app
# -----------------------------------------------
section="project"
key="linux_function_app"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# vm for vnet data gateway (to be confirmed)
# -----------------------------------------------
section="project"
key="vm"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# iot_hub
# -----------------------------------------------
section="project"
key="iot_hub"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# event_hubs
# -----------------------------------------------
section="project"
key="event_hubs"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 

# data_explorer
# -----------------------------------------------
section="project"
key="data_explorer"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# stream_analytics (must be last solution accelerator to be deployed)
# ** IMPORTANT: This step requires event hubs, iot hub, data explorer and sql server to be deployed first
# -----------------------------------------------
section="project"
key="stream_analytics"
backend_config_key="solution-accelerators-${section}-${key//_/}"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 


# # # Approved managed endpoint via Azure CLI
# -----------------------------------------------
# execute approve managed endpoint - function in utils.sh
exec_approve_stream_analytics_managed_private_endpoint