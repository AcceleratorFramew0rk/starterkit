# ------------------------------------------------------------------
# Standalone deployment - acr
# ------------------------------------------------------------------

# prepare and create launchpad - only run once per subscription

sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts

cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts

PREFIX="aoaiuat"
echo $PREFIX

./launchpad.sh $PREFIX

# goto solution accelerator folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr

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

# set the variables
PROJECT_CODE="${PREFIX}"
ENV="sandpit"
VNET_NAME="gcci-vnet-project"
SUBNET_NAME="ServiceSubnet"

# enter your vnet , subnet id and log analytic workspace id from azure portal resource properties page
VNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}"
SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${SUBNET_NAME}"
LAW_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-agency-law/providers/Microsoft.OperationalInsights/workspaces/gcci-agency-workspace"

# terraform init, plan and apply

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-acr.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="vnet_id=${VNET_ID}" \
-var="subnet_id=${SUBNET_ID}" \
-var="log_analytics_workspace_id=${LAW_ID}"  \
-var="prefix=${PROJECT_CODE}"  \
-var="environment=${ENV}" 

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}" \
-var="vnet_id=${VNET_ID}" \
-var="subnet_id=${SUBNET_ID}" \
-var="log_analytics_workspace_id=${LAW_ID}" \
-var="prefix=${PROJECT_CODE}"  \
-var="environment=${ENV}" 

# ------------------------------------------------------------------
# OR using terraform.tfvars file
# ------------------------------------------------------------------

# create terraform.tfvars file
cat <<EOF | sudo tee /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr/example/terraform.tfvars
storage_account_name="${STG_NAME}"
resource_group_name="${RG_NAME}"
vnet_id="${VNET_ID}"
subnet_id="${SUBNET_ID}"
log_analytics_workspace_id="${LAW_ID}"
prefix="${PROJECT_CODE}"
environment="${ENV}"
EOF

sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr/example/terraform.tfvars

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-acr.tfstate"

terraform plan \
-var-file="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr/example/terraform.tfvars" 

terraform apply -auto-approve \
-var-file="/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr/example/terraform.tfvars" 

