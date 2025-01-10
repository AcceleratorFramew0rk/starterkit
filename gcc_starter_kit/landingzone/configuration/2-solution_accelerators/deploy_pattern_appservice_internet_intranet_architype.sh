
# keyvault
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-keyvault.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# app service internet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# app service intranet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service_intranet

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appserviceintranet.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# cosmos db
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/cosmos_db_mongo

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-cosmosdb.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

# # mssql
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/mssql

# terraform init  -reconfigure \
# -backend-config="resource_group_name=nirxuat-rg-launchpad" \
# -backend-config="storage_account_name=nirxuatstgtfstatedxh" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-mssql.tfstate"

# terraform plan \
# -var="storage_account_name=nirxuatstgtfstatedxh" \
# -var="resource_group_name=nirxuat-rg-launchpad"

# terraform apply -auto-approve \
# -var="storage_account_name=nirxuatstgtfstatedxh" \
# -var="resource_group_name=nirxuat-rg-launchpad"


# storage account
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

terraform init  -reconfigure \
-backend-config="resource_group_name=nirxuat-rg-launchpad" \
-backend-config="storage_account_name=nirxuatstgtfstatedxh" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-storageaccount.tfstate"

terraform plan \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=nirxuatstgtfstatedxh" \
-var="resource_group_name=nirxuat-rg-launchpad"
