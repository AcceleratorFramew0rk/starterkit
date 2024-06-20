# devops runner
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/devops/containter_instance

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatenoi" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-devops-container-instance.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

