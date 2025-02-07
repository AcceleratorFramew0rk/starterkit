#!/bin/bash
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

# echo Hello, what is the storage accout name?
# read STG_NAME


# if [[ "$STG_NAME" == "" ]]; then
#     echo "Storage Account Name is empty. ERROR: Please provide an Storage Account Name. Script Exit now."
# else
    
echo "working directory:"
CWD=$(pwd)
echo $CWD
# CONFIG_FILE_PATH="${CWD}/../scripts/config.yaml"
CONFIG_FILE_PATH="./../scripts/config.yaml"
echo $CONFIG_FILE_PATH
eval $(parse_yaml $CONFIG_FILE_PATH "CONFIG_")
# Define your variables


RESOURCE_GROUP_NAME="${CONFIG_resource_group_name}"
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME="${CONFIG_log_analytics_workspace_resource_group_name}"
LOG_ANALYTICS_WORKSPACE_NAME="${CONFIG_log_analytics_workspace_name}"


PROJECT_CODE="${CONFIG_prefix}" 
# Generate resource group name to store state file
RG_NAME="${PROJECT_CODE}-rg-launchpad"

echo "Resource Group Name: ${RG_NAME}"

STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_NAME_PREFIX="${STORAGE_ACCOUNT_NAME_PREFIX//-/}"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
if [[ $? -ne 0 ]]; then
    echo "no storage account"
    exit
else
    # echo $STORAGE_ACCOUNT_INFO
    STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)
    echo "Storage Account Name: ${STG_NAME}"

    echo "updating gcci_platform tfstate..."
    ACCOUNT_INFO=$(az account show 2> /dev/null)
    if [[ $? -ne 0 ]]; then
        echo "no subscription"
        exit
    fi

    SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
    SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
    USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)

    echo "Subscription Id: ${SUB_ID}"
    echo "Subscription Name: ${SUB_NAME}"
    SUBSCRIPTION_ID="${SUB_ID}" # "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"


    MSYS_NO_PATHCONV=1 terraform init  -reconfigure \
    -backend-config="resource_group_name=${RG_NAME}" \
    -backend-config="storage_account_name=${STG_NAME}" \
    -backend-config="container_name=0-launchpad" \
    -backend-config="key=gcci-platform.tfstate"

    # log analytics workspace
    MSYS_NO_PATHCONV=1 terraform state rm azurerm_log_analytics_workspace.gcci_agency_workspace

    MSYS_NO_PATHCONV=1 terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 


    echo "-----------------------------------------------------------------------------"  
    echo "Start creating NSG yaml configuration file"  
    timestamp
    echo "-----------------------------------------------------------------------------"

    # begin rename gcc_starter_kit to folder name

    # goto starter kit parent folder
    cd ./../../../../

    # Get the folder name
    FOLDER_NAME=$(basename "$(pwd)")
    echo "Folder Name: ${FOLDER_NAME}"

    # Escape slashes in the search variable
    search="gcc_starter_kit"
    replace="${FOLDER_NAME}"

    echo $search
    echo $replace
    # Perform replace
    find . -name '*.md' -exec sed -i -e "s/$search/$replace/g" {} +
    find . -name '*.sh' -exec sed -i -e "s/$search/$replace/g" {} +

    # end rename gcc_starter_kit to folder name

    # goto nsg configuration folder
    cd /tf/avm/${replace}/landingzone/configuration/1-landingzones/scripts

    # create nsg yaml file from nsg csv files
    python3 csv_to_yaml.py 

    # replace subnet cidr range from config.yaml file in launchpad
    ./replace.sh


fi
