# intranet egress firewall
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/hub_intranet_egress/firewall_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatethe" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-hub-intranet-egress-firewall.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatethe" \
-var="resource_group_name=aoaiuat-rg-launchpad"
