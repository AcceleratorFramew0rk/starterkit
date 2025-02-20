#!/bin/bash

#------------------------------------------------------------------------
# functions
#------------------------------------------------------------------------
exec_terraform() {

  local tf_state_name=$1
  local path=$2
  local rgname=$3
  local stgname=$4
  local containername=$5

  if [[ -z "$containername" ]]; then
      containername = "2-solution-accelerators"
  fi

  cd $path
  pwd

  terraform init  -reconfigure \
  -backend-config="resource_group_name=${rgname}" \
  -backend-config="storage_account_name=${stgname}" \
  -backend-config="container_name=${containername}" \
  -backend-config="key=${tf_state_name}.tfstate"

  if [ $? -ne 0 ]; then
    echo "Terraform init failed. Exiting."
    echo -e "\e[31mTerraform init failed for ${tf_state_name}. Exiting.\e[0m"
    exit 1
  fi


  terraform plan \
  -var="storage_account_name=${stgname}" \
  -var="resource_group_name=${rgname}"

  if [ $? -ne 0 ]; then
    # echo "Terraform plan failed. Exiting."
    echo -e "\e[31mTerraform plan failed for ${tf_state_name}. Exiting.\e[0m"
    exit 1
  fi


  terraform apply -auto-approve \
  -var="storage_account_name=${stgname}" \
  -var="resource_group_name=${rgname}"   

  if [ $? -ne 0 ]; then
    # echo "Terraform apply failed. Exiting."
    echo -e "\e[31mTerraform apply failed for ${tf_state_name}. Exiting.\e[0m"
    exit 1
  fi


}

#------------------------------------------------------------------------
# end functions
#------------------------------------------------------------------------



# # render config.yaml
# echo "render config.yaml"
# python3 render_config.py

# # perform copy
# echo "copy output_config.yaml to working directory"
# cp "./output_config.yaml" "/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"


#------------------------------------------------------------------------
# end prepare the environment
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# move current config.yaml to working directory ".../0-launchpad/scripts/config.yaml"
#------------------------------------------------------------------------

echo "LANDINGZONE TYPE: $LANDINGZONE_TYPE"

# goto working directory
cd /tf/avm/scripts



#------------------------------------------------------------------------
# end move current config.yaml to working directory ".../0-launchpad/scripts/config.yaml"
#------------------------------------------------------------------------


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
PREFIX=$(yq  -r '.prefix' /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)

echo "PREFIX: ${PREFIX}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"

export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

# #------------------------------------------------------------------------
# # end get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------


#------------------------------------------------------------------------
# 0-launchpad
#------------------------------------------------------------------------

if [[ -z "$STG_NAME" ]]; then
    # execute the import script
    cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad
    ./scripts/import.sh
else
    # execute the import script    
    cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad
    ./scripts/import_update.sh
fi


cd /tf/avm/scripts


#------------------------------------------------------------------------
# end 0-launchpad
#------------------------------------------------------------------------

# # #------------------------------------------------------------------------
# # # get configuration file path, resource group name, storage account name, subscription id, subscription name
# # #------------------------------------------------------------------------
PREFIX=$(yq  -r '.prefix' /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
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

# #------------------------------------------------------------------------
# # end get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------


#------------------------------------------------------------------------
# 1-landing zone
#------------------------------------------------------------------------

# spoke project 
backend_config_key="network-spoke-project"
working_path="/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "1-landingzones"

# spoke devops 
backend_config_key="network-spoke-devops"
working_path="/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "1-landingzones" 

# peering project-devops
backend_config_key="network-peering-project-devops"
working_path="/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops"
exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "1-landingzones" 

#------------------------------------------------------------------------
# end 1-landing zone
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# 2-solution accelerators
#------------------------------------------------------------------------

# goto working directory
cd /tf/avm/scripts

# Define the YAML file
yaml_file="/tf/avm/scripts/config/settings.yaml"

# Check if the file exists
if [[ ! -f "$yaml_file" ]]; then
  echo "YAML file not found: $yaml_file"
  exit 1
fi

# Loop through the top-level keys
for section in $(yq 'keys | .[]' "$yaml_file" -r); do
  echo "Section: $section"

  # Loop through sub-keys for each top-level key
  for key in $(yq ".${section} | keys | .[]" "$yaml_file" -r); do
    value=$(yq ".${section}.${key}" "$yaml_file" -r)

    if [ $value = "true" ]; then
      echo "processing $key: $value"
      clean_key="${key//_/}"
      backend_config_key="solution-accelerators-${section}-${clean_key}"
      working_path="/tf/avm/templates/landingzone/configuration/2-solution_accelerators/${section}/${key}"
      echo "backend_config_key: $backend_config_key"
      echo "working_path: $working_path"

      # exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 
      if [[ "$LANDINGZONE_TYPE" == "application"  || "$LANDINGZONE_TYPE" == "1" ]]; then
        if [[ "$section" == "project"  || "$section" == "devops" ]]; then
          exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 
        else
          echo "Item not configure in landing zone. skip ${section} ${key}"
        fi
      else
        if [[ "$section" == "hub_internet_ingress"  || "$section" == "hub_internet_egress" || "$section" == "hub_intranet_ingress" || "$section" == "hub_intranet_egress" || "$section" == "management" ]]; then
          exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 
        else
          echo "Item not configure in landing zone. skip ${section} ${key}"
        fi
      fi      

    else
      echo "skip ${section} ${key}"
    fi

  done
done

#------------------------------------------------------------------------
# end 2-solution accelerators
#------------------------------------------------------------------------
