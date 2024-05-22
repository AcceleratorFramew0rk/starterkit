cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/hub_internet/firewall_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstateiyp" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-hub-internet-egress-firewall.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstateiyp" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstateiyp" \
-var="resource_group_name=aoaidev-rg-launchpad"
