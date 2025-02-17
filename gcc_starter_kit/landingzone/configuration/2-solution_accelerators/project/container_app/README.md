#!/bin/bash

# ** IMPORTANT **: Provided subnet "ContainerAppSubnet" must have a size of at least /23


# Extract the value of 'prefix' using yq and assign it to the PREFIX variable and generate resource group name to store state file

PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX//-/}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
echo $RG_NAME
echo $STG_NAME

SUBSCRIPTION_ID=$(az account show 2>/dev/null | jq -r ".id")
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"
echo $SUBSCRIPTION_ID

# deploy the solution accelerator


# Linux ASP with two app web and api
# -----------------------------------------------------------------------------------

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

# Linux ASP with one app "web" in Publishing model = Container
# -----------------------------------------------------------------------------------

cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

container_app_name='["web"]'

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="container_app_name=${appservice_name}" 

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="container_app_name=${appservice_name}" 

# Linux ASP with two app "web" and "api" in WebIntranetSubnet and ContainerAppIntranetSubnet
# -----------------------------------------------------------------------------------


cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="subnet_name=ContainerAppIntranetSubnet" \
-var="ingress_subnet_name=WebIntranetSubnet" 

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="subnet_name=ContainerAppIntranetSubnet" \
-var="ingress_subnet_name=WebIntranetSubnet" 
