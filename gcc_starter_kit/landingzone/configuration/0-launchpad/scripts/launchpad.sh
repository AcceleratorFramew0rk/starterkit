#!/bin/bash

# ---------------------------------------------------------------------------------------
# Create storage account and containers for storing terraform state file
#
# Example usage:
#
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts
# PREFIX="aaf"
# ./launchpad.sh $PREFIX
#
# ---------------------------------------------------------------------------------------

# Check if at least one parameter is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [prefix]"
  exit 1
fi

# Assign the first parameter to the variable 'name'
PREFIX=$1

# Generate storage acc name to store state file
LOC="southeastasia"
PROJECT_CODE="${PREFIX}"
RND_NUM=$(env LC_CTYPE=C tr -dc 'a-z' </dev/urandom | fold -w 3 | head -n 1)

RG_NAME="${PROJECT_CODE}-rg-launchpad"
STG_NAME="${PROJECT_CODE}stgtfstate${RND_NUM}"
CONTAINER1="0-launchpad"
CONTAINER2="1-landingzones"
CONTAINER3="2-solution-accelerators"

# Check if the resource group already exists
az group show --name $RG_NAME > /dev/null 2>&1

if [ $? -eq 0 ]; then
    read -p "ERROR: Resource group $RG_NAME already exists. Exiting."
    exit 1
else
    # If the resource group does not exist, attempt to create it
    az group create --name $RG_NAME --location $LOC
    if [ $? -eq 0 ]; then
        echo "Resource group $RG_NAME created successfully."
    else
        read -p "ERROR: Failed to create resource group $RG_NAME. Exiting."
        exit 1
    fi
fi

# Create Storage account and containers for storing state files
az storage account create --name $STG_NAME --resource-group $RG_NAME --location $LOC --sku Standard_LRS --kind StorageV2 --allow-blob-public-access true --min-tls-version TLS1_2

az storage container create --account-name $STG_NAME --name $CONTAINER1 --public-access blob --fail-on-exist
az storage container create --account-name $STG_NAME --name $CONTAINER2 --public-access blob --fail-on-exist
az storage container create --account-name $STG_NAME --name $CONTAINER3 --public-access blob --fail-on-exist

