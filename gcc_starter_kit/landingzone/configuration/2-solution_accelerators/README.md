# goto solution accelerators folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators

# platform common services - firewall, agw, bastion host, tooling server
./deploy_pattern_platform_internet_egress.sh
./deploy_pattern_platform_internet_ingress.sh
./deploy_pattern_platform_intranet_egress.sh
./deploy_pattern_platform_intranet_ingress.sh
./deploy_pattern_platform_management.sh

# devops service - runner container instance
./deploy_pattern_devops_runner.sh

# application aks architype - acr + aks + sql server, keyvaule, storage account
./deploy_pattern_aks_architype.sh

# OR 

# application app service architype - app service + sql server, keyvaule, storage account
./deploy_pattern_appservice_architype.sh

# OR 

# application app service logic app architype - app service + logic app + cosmosdb, keyvaule, storage account
./deploy_pattern_appservice_logicapp_architype.sh

# OR 

# application iot architype - iot hub, stream analytics, event hub, data explorer, app service, apim, sql server
./deploy_pattern_iot_archetype.sh