cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/hub_internet_ingress/frontdoor

terraform init  -reconfigure \
-backend-config="resource_group_name=wms01mr-rg-launchpad" \
-backend-config="storage_account_name=wms01mrstgtfstate6wn" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-hub-internet-ingress-cdn.tfstate"

terraform plan \
-var="storage_account_name=wms01mrstgtfstate6wn" \
-var="resource_group_name=wms01mr-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=wms01mrstgtfstate6wn" \
-var="resource_group_name=wms01mr-rg-launchpad"
