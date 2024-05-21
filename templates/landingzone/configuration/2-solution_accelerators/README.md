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

# aks architype - acr + aks + sql server, keyvaule, storage account
./deploy_pattern_aks_architype.sh

# app service architype - app service + sql server, keyvaule, storage account
./deploy_pattern_appservice_architype.sh