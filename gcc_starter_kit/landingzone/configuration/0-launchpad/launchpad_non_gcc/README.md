# set the prefix here

sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

# create launchpad storage account and containers
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad_non_gcc

# define your prefix or project code
# PREFIX=<your project prefix>
PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)

# create launchpad storage account
./scripts/launchpad.sh $PREFIX

# replace the storage account and resource group name
./scripts/replace.sh $PREFIX

# generate the nsg configuration
./scripts/nsg.sh

# create virtual networks for non gcc environment
# ** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 


cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad_non_gcc

# get storage account and resource group name
RG_NAME=${PREFIX}-rg-launchpad
STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)

echo $RG_NAME
echo $STG_NAME

# deploy virtual networks

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

terraform plan

terraform apply -auto-approve

# to continue, goto landing zone folder and follow the steps in README.md

cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones