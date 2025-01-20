#!/bin/bash

#------------------------------------------------------------------------
# move current config.yaml to working directory ".../0-launchpad/scripts/config.yaml"
#------------------------------------------------------------------------

# goto working directory
cd /tf/avm/scripts

# render config.yaml
echo "render config.yaml"
python3 render_config.py

# perform copy
echo "copy config.yaml to working directory"
cp "./config.yaml" "/tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml"

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
PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)

echo "PREFIX: ${PREFIX}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"

if [[ -z "$STG_NAME" ]]; then
    # execute the import script
    cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad
    ./scripts/import.sh
    # echo "No storage account found matching the prefix."
    # exit
else
    # execute the import script    
    cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad
    ./scripts/import_update.sh
fi


cd /tf/avm/scripts

#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# functions
#------------------------------------------------------------------------
exec_terraform() {

  local tf_state_name=$1
  local path=$2

  cd $path
  pwd

  terraform init  -reconfigure \
  -backend-config="resource_group_name=${RG_NAME}" \
  -backend-config="storage_account_name=${STG_NAME}" \
  -backend-config="container_name=2-solution-accelerators" \
  -backend-config="key=${tf_state_name}.tfstate"

  terraform plan \
  -var="storage_account_name=${STG_NAME}" \
  -var="resource_group_name=${RG_NAME}"

  terraform apply -auto-approve \
  -var="storage_account_name=${STG_NAME}" \
  -var="resource_group_name=${RG_NAME}"   

}

#------------------------------------------------------------------------
# end functions
#------------------------------------------------------------------------

# # #------------------------------------------------------------------------
# # # get configuration file path, resource group name, storage account name, subscription id, subscription name
# # #------------------------------------------------------------------------
# PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
# RG_NAME="${PREFIX}-rg-launchpad"
# STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
# if [[ -z "$STG_NAME" ]]; then
#     echo "No storage account found matching the prefix."
#     exit
# else
#     ACCOUNT_INFO=$(az account show 2> /dev/null)
#     if [[ $? -ne 0 ]]; then
#         echo "no subscription"
#         exit
#     fi
#     SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
#     SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
#     USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)
#     SUBSCRIPTION_ID="${SUB_ID}" 
# fi

# echo "PREFIX: ${PREFIX}"
# echo "Subscription Id: ${SUB_ID}"
# echo "Subscription Name: ${SUB_NAME}"
# echo "Storage Account Name: ${STG_NAME}"
# echo "Resource Group Name: ${RG_NAME}"

# #------------------------------------------------------------------------
# # end get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------


#------------------------------------------------------------------------
# 1-landing zone
#------------------------------------------------------------------------

# spoke project 
backend_config_key="network-spoke-project"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/application/networking_spoke_project"
exec_terraform $backend_config_key $working_path

# spoke devops 
backend_config_key="network-peering-project-devops"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/application/networking_spoke_devops"
exec_terraform $backend_config_key $working_path

# peering project-devops
backend_config_key="network-peering-project-devops"
working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/application/networking_peering_project_devops"
exec_terraform $backend_config_key $working_path

#------------------------------------------------------------------------
# end 1-landing zone
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# 2-solution accelerators
#------------------------------------------------------------------------

# goto working directory
cd /tf/avm/scripts

# Define the YAML file
yaml_file="/tf/avm/scripts/settings.yaml"

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
      working_path="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/${section}/${key}"
      echo "backend_config_key: $backend_config_key"
      echo "working_path: $working_path"
      exec_terraform $backend_config_key $working_path

    else
      echo "skip ${section} ${key}"
    fi

  done
done

#------------------------------------------------------------------------
# end 2-solution accelerators
#------------------------------------------------------------------------
