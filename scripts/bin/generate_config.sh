#!/bin/bash
#------------------------------------------------------------------------
# prepare the environment
#------------------------------------------------------------------------
# Source the prompt.sh file to include its functions and variables
# Source the prompt.sh file to include its functions and variables
# source ./prompt.sh
# source ./prepare_environment.sh

# Source utility scripts
source "$(dirname "$0")/../lib/prompt.sh"
source "$(dirname "$0")/../lib/prepare_environment.sh"

echo "PREFIX: $PREFIX"
echo "VNET Project Name: $VNET_PROJECT_NAME"
echo "VNET DevOps Name: $VNET_DEVOPS_NAME"
echo "The CIDR of the GCCI Project Virtual Network is: $GCCI_VNET_PROJECT_CIDR"
echo "The CIDR of the GCCI DevOps Virtual Network is: $GCCI_VNET_DEVOPS_CIDR"
echo "SETTINGS YAML FILE PATH: $SETTINGS_YAML_FILE_PATH"

# Additional installation steps can go here

# #------------------------------------------------------------------------
# # get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------

# get current subscription id and name
ACCOUNT_INFO=$(az account show 2> /dev/null)
if [[ $? -ne 0 ]]; then
    echo "no subscription"
    exit
fi
SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)
SUBSCRIPTION_ID="${SUB_ID}" 

# get resource group and storage account name
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)

echo "PREFIX: ${PREFIX}"
echo "ENVIRONMENT: ${ENVIRONMENT}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"

export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------


if [[ "$LANDINGZONE_TYPE" == "application"  || "$LANDINGZONE_TYPE" == "1" ]]; then

# Output the variables to a text file (input.yaml)
cat <<EOF > ./../config/input.yaml
subscription_id: "${SUB_ID}"
prefix: "${PREFIX}"
is_prefix: false
is_single_resource_group: false
environment: "${ENVIRONMENT}"
vnets:
  hub_ingress_internet: 
    name:   
    cidr: 
  hub_egress_internet:  
    name:   
    cidr: 
  hub_ingress_intranet:  
    name:  
    cidr: 
  hub_egress_intranet:  
    name:    
    cidr: 
  management:  
    name:     
    cidr: 
  project:  
    name: "$VNET_PROJECT_NAME"
    cidr: "$GCCI_VNET_PROJECT_CIDR"
  devops:  
    name: "$VNET_DEVOPS_NAME"  
    cidr: "$GCCI_VNET_DEVOPS_CIDR"  
EOF

else
# Output the variables to a text file (input.yaml)
cat <<EOF > ./../config/input.yaml
subscription_id: "${SUB_ID}"
prefix: "${PREFIX}"
is_prefix: false
is_single_resource_group: false
environment: "${ENVIRONMENT}"
vnets:
  hub_ingress_internet: 
    name: "$VNET_HUB_INGRESS_INTERNET_NAME" 
    cidr: "$VNET_HUB_INGRESS_INTERNET_CIDR"
  hub_egress_internet:  
    name: "$VNET_HUB_EGRESS_INTERNET_NAME"  
    cidr: "$VNET_HUB_EGRESS_INTERNET_CIDR"
  hub_ingress_intranet:  
    name: "$VNET_HUB_INGRESS_INTRANET_NAME"
    cidr: "$VNET_HUB_INGRESS_INTRANET_CIDR"
  hub_egress_intranet:  
    name: "$VNET_HUB_EGRESS_INTRANET_NAME" 
    cidr: "$VNET_HUB_EGRESS_INTRANET_CIDR"
  management:  
    name: "$VNET_MANAGEMENT_NAME"    
    cidr: "$VNET_MANAGEMENT_CIDR" 
  project:  
    name: 
    cidr: 
  devops:  
    name: 
    cidr: 
EOF

fi


# render config.yaml
echo "render config.yaml"

# "Usage: python3 render_config.py <settings_yaml_file_path>
python3 ./../lib/render_config.py $SETTINGS_YAML_FILE_PATH $LANDINGZONE_TYPE
if [ $? -ne 0 ]; then
  echo "Terraform init failed. Exiting."
  echo -e "\e[31mrender_config execution failed. Exiting.\e[0m"
  exit 1
fi
# perform copy
echo "copy output_config.yaml to working directory"
cp "$(dirname "$0")/../config/output_config.yaml" "/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"

