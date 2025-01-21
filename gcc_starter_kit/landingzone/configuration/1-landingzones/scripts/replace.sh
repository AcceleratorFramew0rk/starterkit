#!/bin/bash

# sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/nsg/csv/replace.sh

# begin network security group - replace cidr with config data

# app subnet
# search="{{cidr_internet_zone_subnet_app}}"
# replace="100.64.0.32/27"
# # perform replace
# find . -name '*.csv' -exec sed -i -e "s/$search/$replace/g" {} \;

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

# Define a timestamp function
timestamp() {
  date +"%T" # current time
}

configure_nsg () {
  # search="{{cidr_internet_zone_subnet_app}}"
  # replace="100.64.0.32/27"
  local search="$1"
  local replace=$(echo "$2" | sed 's/ //g') # "$2"

  # Check if the value is empty or "none" and set it to "VirtualNetwork" if true
   if [[ -z "${replace}" || "${replace}" == "none" ]]; then
      replace="VirtualNetwork"
   fi
  
  # Escape slashes in the search variable
  search_escaped=$(echo "$search" | sed 's/[\/&]/\\&/g')
  replace_escaped=$(echo "$replace" | sed 's/[\/&]/\\&/g')
  # Perform replace
  find . -name 'config_nsg.yaml' -exec sed -i -e "s/$search_escaped/$replace_escaped/g" {} +
}
#------------------------------------------------------------------------
# end functions
#------------------------------------------------------------------------


# CONFIG_FILE_PATH="/tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml"
CONFIG_FILE_PATH="./../../0-launchpad/scripts/config.yaml"
echo $CONFIG_FILE_PATH
eval $(parse_yaml $CONFIG_FILE_PATH "CONFIG_")
# e,g,
# "${CONFIG_subnets_project_WebSubnet_address_prefixes_1}"

echo "here is the cidr"
echo $CONFIG_subnets_project_WebSubnet_address_prefixes

# "${original_string//[\[\]]/}"

# project vnets subnets
configure_nsg "{{project_websubnet_address_prefixes}}" "${CONFIG_subnets_project_WebSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_appsubnet_address_prefixes}}" "${CONFIG_subnets_project_AppSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_dbsubnet_address_prefixes}}" "${CONFIG_subnets_project_DbSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_servicesubnet_address_prefixes}}" "${CONFIG_subnets_project_ServiceSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_functionappsubnet_address_prefixes}}" "${CONFIG_subnets_project_FunctionAppSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_apisubnet_address_prefixes}}" "${CONFIG_subnets_project_ApiSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_systemnodepoolsubnet_address_prefixes}}" "${CONFIG_subnets_project_SystemNodePoolSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_usernodepoolsubnet_address_prefixes}}" "${CONFIG_subnets_project_UserNodePoolSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_aisubnet_address_prefixes}}" "${CONFIG_subnets_project_AiSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_logicappsubnet_address_prefixes}}" "${CONFIG_subnets_project_LogicAppSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_cisubnet_address_prefixes}}" "${CONFIG_subnets_project_CiSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_servicebussubnet_address_prefixes}}" "${CONFIG_subnets_project_ServiceBusSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_cosmosdbsubnet_address_prefixes}}" "${CONFIG_subnets_project_CosmosDbSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_logicappsubnet_address_prefixes}}" "${CONFIG_subnets_project_LogicAppSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{project_appservicesubnet_address_prefixes}}" "${CONFIG_subnets_project_AppServiceSubnet_address_prefixes//[\[\]]/}"


# management
configure_nsg "{{management_infrasubnet_address_prefixes}}" "${CONFIG_subnets_management_InfraSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{management_securitysubnet_address_prefixes}}" "${CONFIG_subnets_management_SecuritySubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{management_azurebastionsubnet_address_prefixes}}" "${CONFIG_subnets_management_AzureBastionSubnet_address_prefixes//[\[\]]/}"

# devops
configure_nsg "{{devops_runnersubnet_address_prefixes}}" "${CONFIG_subnets_devops_RunnerSubnet_address_prefixes//[\[\]]/}"

# ingress/egress
configure_nsg "{{hub_internet_egress_firewallsubnet_address_prefixes}}" "${CONFIG_subnets_hub_internet_egress_AzureFirewallSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{hub_internet_ingress_firewallsubnet_address_prefixes}}" "${CONFIG_subnets_hub_internet_ingress_AzureFirewallSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{hub_internet_ingress_agwsubnet_address_prefixes}}" "${CONFIG_subnets_hub_internet_ingress_AgwSubnet_address_prefixes//[\[\]]/}"

configure_nsg "{{hub_intranet_egress_firewallsubnet_address_prefixes}}" "${CONFIG_subnets_hub_intranet_egress_AzureFirewallSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{hub_intranet_ingress_firewallsubnet_address_prefixes}}" "${CONFIG_subnets_hub_intranet_ingress_AzureFirewallSubnet_address_prefixes//[\[\]]/}"
configure_nsg "{{hub_intranet_ingress_agwsubnet_address_prefixes}}" "${CONFIG_subnets_hub_intranet_ingress_AgwSubnet_address_prefixes//[\[\]]/}"


# end network security group - replace cidr with config data

