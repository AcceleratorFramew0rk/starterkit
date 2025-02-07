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



# -------------------------------------------------------------------------
# Approved stream analytics managed private endpoint via Azure CLI
# -------------------------------------------------------------------------
# Sample Command
# az network private-endpoint-connection approve -g MyResourceGroup -n MyPrivateEndpoint --resource-name MySA --type Microsoft.Storage/storageAccounts --description "Approved"

exec_approve_stream_analytics_managed_private_endpoint() {

  PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)

  # iot hub
  # --------------------------------

  TYPE="Microsoft.Devices/IotHubs"
  RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-iothub')].[name] | [0]"   -o tsv)
  RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"  --query "[0].name"   --output tsv)
  CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)
  echo $PREFIX
  echo $RESOURCE_GROUP_NAME
  echo $RESOURCE_NAME
  echo $CONNECTION_NAME

  az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"


  # event hub
  # --------------------------------

  TYPE="Microsoft.EventHub/namespaces"
  RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-eventhub')].[name] | [0]"   -o tsv)
  RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"   --query "[0].name"   --output tsv)
  CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)
  echo $PREFIX
  echo $RESOURCE_GROUP_NAME
  echo $RESOURCE_NAME
  echo $CONNECTION_NAME

  az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"


  # data explorer
  # --------------------------------

  TYPE="Microsoft.Kusto/clusters"
  RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-dataexplorer')].[name] | [0]"   -o tsv)
  RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"   --query "[0].name"   --output tsv)
  CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)

  echo $PREFIX
  echo $RESOURCE_GROUP_NAME
  echo $RESOURCE_NAME
  echo $CONNECTION_NAME

  az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"



  # sql server
  # --------------------------------

  TYPE="Microsoft.Sql/servers"
  RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-mssql')].[name] | [0]"   -o tsv)
  RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type Microsoft.Sql/servers   --query "[0].name"   --output tsv)
  CONNECTION_NAME=$(az network private-endpoint-connection list   -g "${RESOURCE_GROUP_NAME}"   -n "${RESOURCE_NAME}"   --type  "${TYPE}"    --query "[?starts_with(name, 'saprivateendpoint')].[name] | [0]"   -o tsv)

  echo $PREFIX
  echo $RESOURCE_GROUP_NAME
  echo $RESOURCE_NAME
  echo $CONNECTION_NAME

  az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"


  # storage account
  # --------------------------------

  TYPE="Microsoft.Storage/storageAccounts"
  RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-streamanalytics')].[name] | [0]"   -o tsv)
  RESOURCE_NAME=$(az resource list  --resource-group $RESOURCE_GROUP_NAME  --resource-type "${TYPE}"  --query "[0].name"  --output tsv)
  CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n $RESOURCE_NAME --type "${TYPE}"  --query "[?starts_with(name, '$RESOURCE_NAME')].[name] | [0]" -o tsv)

  echo $PREFIX
  echo $RESOURCE_GROUP_NAME
  echo $RESOURCE_NAME
  echo $CONNECTION_NAME

  az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"

}
# -------------------------------------------------------------------------
# End Approved via Azure CLI
# -------------------------------------------------------------------------
