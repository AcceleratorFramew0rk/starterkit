# egress internet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_internet_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatenoi" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-internet-egress.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

# ingress internet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_internet_ingress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatenoi" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-internet-ingress.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

# egress intranet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatenoi" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-intranet-egress.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

# ingress intranet
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_ingress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatenoi" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-intranet-ingress.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"


# management
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/platform/networking_spoke_management

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaiuat-rg-launchpad" \
-backend-config="storage_account_name=aoaiuatstgtfstatenoi" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-spoke-management.tfstate"

terraform plan \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaiuatstgtfstatenoi" \
-var="resource_group_name=aoaiuat-rg-launchpad"

