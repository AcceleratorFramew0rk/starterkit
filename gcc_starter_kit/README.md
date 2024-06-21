# Starter kit for GCC

## goto working directory
```bash
cd /tf/avm/gcc_starter_kit
```

## (Optional) Setup GCC Simulator Development Environment
```bash
cd /tf/avm/gcc_starter_kit/0-setup_gcc_dev_env

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

## launchpad

### config.yaml

Please use VS Code to edit the config.yaml file located at /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad/. 
Review and, if necessary, modify the details of the project subnets and cidr ranges.


### import gcci tfstate and create launchpad storage account and containers
```bash
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad

./import.sh
```


### to continue, goto README.md under the folder /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones

## landing zones
goto landing zone folder
```bash
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones
```

### deploy platform landing zone
```bash
./deploy_platform_landingzone.sh
```

### deploy application landing zone
```bash
./deploy_application_landingzone.sh
```

## solution accelerators
goto solution accelerators folder
```bash
/tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
```


### deploy platform common services - firewall, agw, bastion host, tooling server
```bash
./deploy_pattern_platform_internet_egress.sh
./deploy_pattern_platform_internet_ingress.sh
./deploy_pattern_platform_intranet_egress.sh
./deploy_pattern_platform_intranet_ingress.sh
./deploy_pattern_platform_management.sh
```
### deploy devops service - runner container instance
```bash
./deploy_pattern_devops_runner.sh
```
### deploy aks architype - acr + aks + sql server, keyvault, storage account
```bash
./deploy_pattern_aks_architype.sh
```
### deploy app service architype - app service + sql server, keyvault, storage account
```bash
./deploy_pattern_appservice_architype.sh
```
