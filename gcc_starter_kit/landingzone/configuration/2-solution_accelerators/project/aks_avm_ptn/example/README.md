# ------------------------------------------------------------------
# Standalone deployment - aks avm private cluster
# ------------------------------------------------------------------

# prepare and create launchpad - only run once per subscription

sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts

cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts

PREFIX="aaf"
echo $PREFIX

./launchpad.sh $PREFIX

# goto solution accelerator folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn

# get subscription id
ACCOUNT_INFO=$(az account show 2> /dev/null)
SUBSCRIPTION_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
echo $SUBSCRIPTION_ID

# get resource group name and storage account name
RG_NAME=${PREFIX}-rg-launchpad
STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)

echo $RG_NAME
echo $STG_NAME

# ** IMPORTANT - find out the random code from the storage account name and replace xxx for RND_NUM 
PROJECT_CODE="${PREFIX}"
ENV="sandpit"
VNET_NAME="gcci-vnet-project"
SYSTEMNODE_SUBNET_NAME="SystemNodePoolSubnet"
USERNODE_SUBNET_NAME="UserNodePoolSubnet"

# enter your vnet , subnet id and log analytic workspace id from azure portal resource properties page
VNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}"
USERNODE_SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${USERNODE_SUBNET_NAME}"
SYSTEMNODE_SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${SYSTEMNODE_SUBNET_NAME}"
LAW_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-agency-law/providers/Microsoft.OperationalInsights/workspaces/gcci-agency-workspace"

# terraform init, plan and apply

terraform init  -reconfigure \
-backend-config="resource_group_name=${PROJECT_CODE}-rg-launchpad" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-akspte.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${PROJECT_CODE}-rg-launchpad" \
-var="vnet_id=${VNET_ID}" \
-var="log_analytics_workspace_id=${LAW_ID}"  \
-var="prefix=${PROJECT_CODE}"  \
-var="environment=${ENV}" \
-var="systemnode_subnet_id=${SYSTEMNODE_SUBNET_ID}" \
-var="usernode_subnet_id=${USERNODE_SUBNET_ID}" 

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${PROJECT_CODE}-rg-launchpad" \
-var="vnet_id=${VNET_ID}" \
-var="log_analytics_workspace_id=${LAW_ID}" \
-var="prefix=${PROJECT_CODE}"  \
-var="environment=${ENV}"  \
-var="systemnode_subnet_id=${SYSTEMNODE_SUBNET_ID}" \
-var="usernode_subnet_id=${USERNODE_SUBNET_ID}" 