# app service
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# mssql
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

# # keyvault
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

# terraform init  -reconfigure \
# -backend-config="resource_group_name={{resource_group_name}}" \
# -backend-config="storage_account_name={{storage_account_name}}" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-keyvault.tfstate"

# terraform plan \
# -var="storage_account_name={{storage_account_name}}" \
# -var="resource_group_name={{resource_group_name}}"

# terraform apply -auto-approve \
# -var="storage_account_name={{storage_account_name}}" \
# -var="resource_group_name={{resource_group_name}}"

# # storage account
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

# terraform init  -reconfigure \
# -backend-config="resource_group_name={{resource_group_name}}" \
# -backend-config="storage_account_name={{storage_account_name}}" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-storageaccount.tfstate"

# terraform plan \
# -var="storage_account_name={{storage_account_name}}" \
# -var="resource_group_name={{resource_group_name}}"

# terraform apply -auto-approve \
# -var="storage_account_name={{storage_account_name}}" \
# -var="resource_group_name={{resource_group_name}}"
