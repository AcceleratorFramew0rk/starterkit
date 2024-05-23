# goto working directory
cd /tf/avm/gcc_starter_kit

# import gcci tfstate and create launchpad storage account and containers
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad
./import.sh

# to continue, goto README.md under the folder /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones

# goto landing zone folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones

# platform landing zone
./deploy_platform_landingzone.sh

# application landing zone
./deploy_application_landingzone.sh

# goto solution accelerators folder
/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators

# platform common services - firewall, agw, bastion host, tooling server
./deploy_pattern_platform_internet_egress.sh
./deploy_pattern_platform_internet_ingress.sh
./deploy_pattern_platform_intranet_egress.sh
./deploy_pattern_platform_intranet_ingress.sh
./deploy_pattern_platform_management.sh

# devops service - runner container instance
./deploy_pattern_devops_runner.sh

# aks architype - acr + aks + sql server, keyvault, storage account
./deploy_pattern_aks_architype.sh

# app service architype - app service + sql server, keyvault, storage account
./deploy_pattern_appservice_architype.sh