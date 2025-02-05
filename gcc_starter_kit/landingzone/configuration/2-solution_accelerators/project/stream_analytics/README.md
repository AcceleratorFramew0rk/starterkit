#!/bin/bash

# Extract the value of 'prefix' using yq and assign it to the PREFIX variable and generate resource group name to store state file

PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
echo $RG_NAME
echo $STG_NAME

# deploy the solution accelerator

cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/stream_analytics

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-streamanalytics.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# -------------------------------------------------------------------------
# Approved stream analytics managed private endpoint via Azure CLI
# -------------------------------------------------------------------------

<!-- az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics" -->

# Sample Command
# az network private-endpoint-connection approve -g MyResourceGroup -n MyPrivateEndpoint --resource-name MySA --type Microsoft.Storage/storageAccounts --description "Approved"

PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)

# iot hub
# --------------------------------

TYPE="Microsoft.Devices/IotHubs"
RESOURCE_GROUP_NAME="${PREFIX}-rg-solution-accelerators-iothub"
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
RESOURCE_GROUP_NAME="${PREFIX}-rg-solution-accelerators-eventhub"
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
RESOURCE_GROUP_NAME="${PREFIX}-rg-solution-accelerators-dataexplorer"
RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"   --query "[0].name"   --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)

echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"



# sql server
# --------------------------------

# saprivateendpointsqlserver-a5906ba6-b366-439e-a7f8-0837f1c5a467
TYPE="Microsoft.Sql/servers"
RESOURCE_GROUP_NAME="${PREFIX}-rg-solution-accelerators-mssql"
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
RESOURCE_GROUP_NAME="${PREFIX}-rg-solution-accelerators-streamanalytics"
RESOURCE_NAME=$(az resource list  --resource-group $RESOURCE_GROUP_NAME  --resource-type "${TYPE}"  --query "[0].name"  --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n $RESOURCE_NAME --type "${TYPE}"  --query "[?starts_with(name, '$RESOURCE_NAME')].[name] | [0]" -o tsv)

echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"

# -------------------------------------------------------------------------
# End Approved via Azure CLI
# -------------------------------------------------------------------------
