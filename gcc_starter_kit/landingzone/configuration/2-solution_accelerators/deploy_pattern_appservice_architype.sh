# app service
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/app_service

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatepcz" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-appservice.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

# mssql
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/mssql

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatepcz" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-mssql.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

# keyvault
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatepcz" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-keyvault.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

# storage account
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

# terraform init  -reconfigure \
# -backend-config="resource_group_name=aoaidev-rg-launchpad" \
# -backend-config="storage_account_name=aoaidevstgtfstatepcz" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-storageaccount.tfstate"

# terraform plan \
# -var="storage_account_name=aoaidevstgtfstatepcz" \
# -var="resource_group_name=aoaidev-rg-launchpad"

# terraform apply -auto-approve \
# -var="storage_account_name=aoaidevstgtfstatepcz" \
# -var="resource_group_name=aoaidev-rg-launchpad"
