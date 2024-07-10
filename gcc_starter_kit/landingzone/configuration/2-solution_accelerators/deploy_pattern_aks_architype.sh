# acr
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/acr

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatethe" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-acr.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

# aks
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatethe" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-aks.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

# mssql
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/mssql

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatethe" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-mssql.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

# # keyvault - sql has keyvault already - do not execute this
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/keyvault

# terraform init  -reconfigure \
# -backend-config="resource_group_name=aoaiuat-rg-launchpad" \
# -backend-config="storage_account_name=aoaiuatstgtfstatethe" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-keyvault.tfstate"

# terraform plan \
# -var="storage_account_name=aoaiuatstgtfstatethe" \
# -var="resource_group_name=aoaiuat-rg-launchpad"

# terraform apply -auto-approve \
# -var="storage_account_name=aoaiuatstgtfstatethe" \
# -var="resource_group_name=aoaiuat-rg-launchpad"

# # storage account
# cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/storage_account

# terraform init  -reconfigure \
# -backend-config="resource_group_name=aoaiuat-rg-launchpad" \
# -backend-config="storage_account_name=aoaiuatstgtfstatethe" \
# -backend-config="container_name=2-solution-accelerators" \
# -backend-config="key=solution_accelerators-project-storageaccount.tfstate"

# terraform plan \
# -var="storage_account_name=aoaiuatstgtfstatethe" \
# -var="resource_group_name=aoaiuat-rg-launchpad"

# terraform apply -auto-approve \
# -var="storage_account_name=aoaiuatstgtfstatethe" \
# -var="resource_group_name=aoaiuat-rg-launchpad"
