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

echo Hello, what is the storage accout name?
read STG_NAME

if [[ "$STG_NAME" == "" ]]; then
    echo "Storage Account Name is empty. ERROR: Please provide an Storage Account Name. Script Exit now."
else
        
    echo "working directory:"
    CWD=$(pwd)
    echo $CWD
    CONFIG_FILE_PATH="${CWD}/config.yaml"
    echo $CONFIG_FILE_PATH
    eval $(parse_yaml $CONFIG_FILE_PATH "CONFIG_")
    # Define your variables
    PROJECT_CODE="${CONFIG_prefix}" 
    # Generate resource group name to store state file
    RG_NAME="${PROJECT_CODE}-rg-launchpad"

    echo "Resource Group Name: ${RG_NAME}"
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
    -backend-config="resource_group_name=ttsdev-rg-launchpad" \
    -backend-config="storage_account_name=ttsdevstgtfstategof" \
    -backend-config="container_name=0-launchpad" \
    -backend-config="key=gcci-platform.tfstate"

    # log analytics workspace
    MSYS_NO_PATHCONV=1 terraform state rm azurerm_log_analytics_workspace.gcci_agency_workspace

    MSYS_NO_PATHCONV=1 terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/gcci-agency-law/providers/Microsoft.OperationalInsights/workspaces/gcci-agency-workspace" 



    echo "-----------------------------------------------------------------------------"  
    echo "Start creating NSG yaml configuration file"  
    timestamp
    echo "-----------------------------------------------------------------------------"

    # goto nsg configuration folder
    cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/nsg

    # create nsg yaml file from nsg csv files
    python3 csv_to_yaml.py 

    # replace subnet cidr range from config.yaml file in launchpad
    ./replace.sh

    echo "-----------------------------------------------------------------------------"  
    echo "End creating NSG yaml configuration file"  
    timestamp
    echo "-----------------------------------------------------------------------------"

    read -p "Press enter to continue..."

fi
