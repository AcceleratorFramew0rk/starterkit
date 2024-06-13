cd {{working dirctory}}

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatepcz" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-????????.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"
