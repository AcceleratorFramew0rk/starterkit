#!/bin/bash

#------------------------------------------------------------------------
# functions
#------------------------------------------------------------------------
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

#------------------------------------------------------------------------
# get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------
CONFIG_FILE_PATH="/tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml"
echo $CONFIG_FILE_PATH
eval $(parse_yaml $CONFIG_FILE_PATH "CONFIG_")
# Define your variables
PROJECT_CODE="${CONFIG_prefix}" 
PREFIX="${CONFIG_prefix}" 
# Generate resource group name to store state file
RG_NAME="${PROJECT_CODE}-rg-launchpad"

STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
if [[ $? -ne 0 ]]; then
    echo "no storage account"
    exit
else
    STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)
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
#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------


echo "PREFIX: ${PREFIX}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"


# egress internet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_internet_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-internet-egress.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# ingress internet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_internet_ingress

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-internet-ingress.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# egress intranet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-intranet-egress.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# ingress intranet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_ingress

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-intranet-ingress.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"


# management
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_spoke_management

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-spoke-management.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

