# internet ingress agw
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/hub_internet_ingress/agw

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatepcz" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-hub-internet-ingress-agw.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

# internet ingress firewall
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/hub_internet_ingress/firewall_ingress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatepcz" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-hub-internet-ingress-firewall.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatepcz" \
-var="resource_group_name=aoaidev-rg-launchpad"




