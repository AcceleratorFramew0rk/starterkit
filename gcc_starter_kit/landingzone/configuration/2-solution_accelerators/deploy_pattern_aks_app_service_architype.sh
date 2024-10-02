# -----------------------------------------------------------------------------------------------------
# keyvault - ServiceSubnet - is the first resource to be deployed in the solution accelerators. 
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-keyvault.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# -----------------------------------------------------------------------------------------------------
# acr - ServiceSubnet 
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-acr.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# -----------------------------------------------------------------------------------------------------
# aks private cluster - will reference the acr above to assign acrpull role to the aks service principal
# -----------------------------------------------------------------------------------------------------
# SystemNodeSubnet, UserNodeSubnet, UserNodeIntranetSubnet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-aks.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# -----------------------------------------------------------------------------------------------------
# mssql - DbSubnet 
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/mssql

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-mssql.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# -----------------------------------------------------------------------------------------------------
# redis cache - DbSubnet
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/redis_cache

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-rediscache.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"


# -----------------------------------------------------------------------------------------------------
# app service - ServiceSubnet (Inbound) + AppServiceSubnet (VNet Integration) 
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service_windows

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}" 
# \
# -var="windows_fx_version=DOTNETCORE|8.0" \
# -var="kind=Windows" 


terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}" 
# \
# -var="windows_fx_version=DOTNETCORE|8.0"\
# -var="kind=Windows" 

# -----------------------------------------------------------------------------------------------------
# storage account
# -----------------------------------------------------------------------------------------------------
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-storageaccount.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# -----------------------------------------------------------------------------------------------------
# vm - ai - AiSubnet - windows server 2022 server
# -----------------------------------------------------------------------------------------------------
# default is deploy to AppSubnet, change the subnet_id to AiSubnet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/vm

# ** IMPORTANT - define subnet_id for the VM deployment
VNET_NAME="gcci-vnet-project"
SUBNET_NAME="AiSubnet"
SUBSCRIPTION_ID=$(echo "$(az account show 2> /dev/null)" | jq ".id" -r)
echo $SUBSCRIPTION_ID
SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${SUBNET_NAME}"
echo $SUBNET_ID


terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-vm-windows.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}" \
-var="subnet_id=${SUBNET_ID}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}" \
-var="subnet_id=${SUBNET_ID}"


# -----------------------------------------------------------------------------------------------------
# vm - oss - AiSubnet - linux OS - Ubuntu
# -----------------------------------------------------------------------------------------------------
# default is deploy to AppSubnet, change the subnet_id to AiSubnet
# virtualmachine_os_type is default to Windows, set this to Linux
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/vm

# ** IMPORTANT - define subnet_id for the VM deployment
VNET_NAME="gcci-vnet-project"
SUBNET_NAME="AiSubnet"
SUBSCRIPTION_ID=$(echo "$(az account show 2> /dev/null)" | jq ".id" -r)
echo $SUBSCRIPTION_ID
SUBNET_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${SUBNET_NAME}"
echo $SUBNET_ID


terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-vm-linux.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}" \
-var="subnet_id=${SUBNET_ID}" \
-var="virtualmachine_os_type=Linux" 

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}" \
-var="subnet_id=${SUBNET_ID}" \
-var="virtualmachine_os_type=Linux" 
