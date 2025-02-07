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

generate_random_string() {
    echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 3 | head -n 1 | tr '[:upper:]' '[:lower:]')
}

# Define the function for configuring project files
configure_project_files() {
  local search_word="$1"
  local replace_word="$2"
  local exclude_file="import.sh" # The file to exclude from the search and replace

  echo " "
  echo "-----------------------------------------------------------------------------"  
  echo "Configure files for project with search word $search_word"  
  timestamp
  echo "-----------------------------------------------------------------------------"  

  # Check if the directory exists
  if [[ -d "$DIRECTORY_PATH" ]]; then
      # Perform the search and replace, excluding the specified file
      # find only terraform.tf files
      # find "$DIRECTORY_PATH" -name 'terraform.tf' -exec grep -Iq . {} \; -print | while read file; do
      find "$DIRECTORY_PATH" -type f ! -name "$exclude_file" -exec grep -Iq . {} \; -print | while read file; do
          sed -i -e "s/$search_word/$replace_word/g" "$file"
      done
      echo "Replacement complete in directory: $DIRECTORY_PATH"
  else
      echo "Directory not found."
  fi
}

# Define a timestamp function
timestamp() {
  date +"%T" # current time
}
#------------------------------------------------------------------------
# end functions
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# init all folders and terraform.tf files
#------------------------------------------------------------------------

echo "init files"

#------------------------------------------------------------------------
# get current subscriptin information
#------------------------------------------------------------------------

ACCOUNT_INFO=$(az account show 2> /dev/null)
if [[ $? -ne 0 ]]; then
    echo "no subscription"
    exit
fi

SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)

STATUS_LINE="$USER_NAME @"

if [[ "$SUB_ID" == "MY_PERSONAL_SUBSCRIPTION_ID" ]]; then
    STATUS_LINE="$STATUS_LINE 🏠"
elif [[ "$SUB_ID" == "MY_WORK_SUBSCRIPTION_ID" ]]; then
    STATUS_LINE="$STATUS_LINE 🏢"
else
    STATUS_LINE="$STATUS_LINE $SUB_NAME"
fi

echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "${STATUS_LINE}"

#------------------------------------------------------------------------
# read config.yaml file data
#------------------------------------------------------------------------

# will put CONFIG_ in front of each variable finded in config.yml (it is the $2 and $prefix in function parse_yaml) line 4 and 15.
echo "working directory:"
CWD=$(pwd)
echo $CWD
# CONFIG_FILE_PATH="${CWD}/../scripts/config.yaml"
CONFIG_FILE_PATH="./../scripts/config.yaml"
echo $CONFIG_FILE_PATH
eval $(parse_yaml $CONFIG_FILE_PATH "CONFIG_")

#------------------------------------------------------------------------
# generate gcc_starter_kit
#------------------------------------------------------------------------

RESOURCE_GROUP_NAME="${CONFIG_resource_group_name}"
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME="${CONFIG_log_analytics_workspace_resource_group_name}"
LOG_ANALYTICS_WORKSPACE_NAME="${CONFIG_log_analytics_workspace_name}"

# Define your variables
PROJECT_CODE="${CONFIG_prefix}" 
SUBSCRIPTION_ID="${SUB_ID}" # "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx"

# Generate resource group name to store state file
RG_NAME="${PROJECT_CODE}-rg-launchpad"

# Location
LOC="${CONFIG_location}" # "southeastasia"

# Generate storage acc name to store state file
RND_NUM=$(env LC_CTYPE=C tr -dc 'a-z' </dev/urandom | fold -w 3 | head -n 1)
STG_NAME="${PROJECT_CODE}stgtfstate${RND_NUM}"
STG_NAME="${STG_NAME//-/}"
CONTAINER1="0-launchpad"
CONTAINER2="1-landingzones"
CONTAINER3="2-solution-accelerators"

echo " "
echo "Random string: ${RND_NUM}"
echo "Resource Group Name: ${RG_NAME}"
echo "Storage Account Name: ${STG_NAME}"

echo "-----------------------------------------------------------------------------"  
echo "Begin launchpad storage account"  
timestamp
echo "-----------------------------------------------------------------------------"  

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
if [ $? -eq 0 ]; then
  az storage account create --name $STG_NAME --resource-group $RG_NAME --location $LOC --sku Standard_LRS --kind StorageV2 --allow-blob-public-access true --min-tls-version TLS1_2
fi
if [ $? -eq 0 ]; then
  az storage container create --account-name $STG_NAME --name $CONTAINER1 --public-access blob --fail-on-exist
fi
if [ $? -eq 0 ]; then
  az storage container create --account-name $STG_NAME --name $CONTAINER2 --public-access blob --fail-on-exist
fi
if [ $? -eq 0 ]; then
  az storage container create --account-name $STG_NAME --name $CONTAINER3 --public-access blob --fail-on-exist
fi

echo "-----------------------------------------------------------------------------"  
echo "End launchpad storage account"  
timestamp
echo "-----------------------------------------------------------------------------"  

echo "-----------------------------------------------------------------------------"  
echo "Start replacing variables"  
timestamp
echo "-----------------------------------------------------------------------------"  

# Call the function with different search and replace terms
# Update this path based on your environment (Git Bash/Cygwin or WSL)
# DIRECTORY_PATH="/tf/avm/gcc_starter_kit/landingzone"      
DIRECTORY_PATH="./../../../configuration"               
configure_project_files "{{resource_group_name}}" "$RG_NAME"
configure_project_files "{{storage_account_name}}" "$STG_NAME"
configure_project_files "{{prefix}}" "$PROJECT_CODE"

echo "-----------------------------------------------------------------------------"  
echo "Start terraform import commands"  
timestamp
echo "-----------------------------------------------------------------------------"  

MSYS_NO_PATHCONV=1 terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"


# vnets:
#   # IMPORTANT: leave empty if there is no such virtual network   
#   ingress_internet: "gcci-vnet-ingress-internet"   
#   egress_internet: "gcci-vnet-egress-internet"  
#   ingress_intranet: "gcci-vnet-ingress-intranet" 
#   egress_intranet: "gcci-vnet-egress-intranet"  
#   project: "gcci-vnet-project"   
#   management: "gcci-vnet-management"   
#   devops: "gcci-vnet-devops" 


echo "vnets:" 
echo $CONFIG_vnets_hub_ingress_internet_name
echo $CONFIG_vnets_hub_egress_internet_name
echo $CONFIG_vnets_hub_ingress_intranet_name
echo $CONFIG_vnets_hub_egress_intranet_name
echo $CONFIG_vnets_project_name
echo $CONFIG_vnets_management_name
echo $CONFIG_vnets_devops_name

# Replace the hardcoded subscription ID with the $SUBSCRIPTION_ID variable
# resource group
MSYS_NO_PATHCONV=1 terraform import "azurerm_resource_group.gcci_platform" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}" 
MSYS_NO_PATHCONV=1 terraform import "azurerm_resource_group.gcci_agency_law" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}" 

# virtual networks
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_ingress_internet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-ingress-internet" 
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_egress_internet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-egress-internet" 
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_ingress_intranet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-ingress-intranet" 
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_egress_intranet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-egress-intranet" 
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_project" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-project" 
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_management" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-management" 
# MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_devops" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/gcci-vnet-devops" 

if [[ "$CONFIG_vnets_hub_ingress_internet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_ingress_internet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_ingress_internet_name" 
fi

if [[ "$CONFIG_vnets_hub_egress_internet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_egress_internet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_egress_internet_name" 
fi

if [[ "$CONFIG_vnets_hub_ingress_intranet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_ingress_intranet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_ingress_intranet_name" 
fi

if [[ "$CONFIG_vnets_hub_egress_intranet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_egress_intranet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_egress_intranet_name" 
fi

if [[ "$CONFIG_vnets_project_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_project" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_project_name" 
fi

if [[ "$CONFIG_vnets_management_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_management" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_management_name" 
fi

if [[ "$CONFIG_vnets_devops_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_devops" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_devops_name" 
fi

# log analytics workspace
MSYS_NO_PATHCONV=1 terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 

echo "-----------------------------------------------------------------------------"  
echo "End import gcci resources"  
timestamp
echo "-----------------------------------------------------------------------------"

# # Wait for the user to press enter before closing
echo "output:"
echo "RESOURCE_GROUP_NAME: ${RG_NAME}"
echo "STORAGE_ACCONT_NAME: ${STG_NAME}"


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
# goto nsg configuration folder
# cd /tf/avm/${replace}/landingzone/configuration/1-landingzones/scripts
cd ./landingzone/configuration/1-landingzones/scripts

# create nsg yaml file from nsg csv files
python3 csv_to_yaml.py 

# replace subnet cidr range from config.yaml file in launchpad
./replace.sh


echo "-----------------------------------------------------------------------------"  
echo "End creating NSG yaml configuration file"  
timestamp
echo "-----------------------------------------------------------------------------"

# read -p "Press enter to continue..."
