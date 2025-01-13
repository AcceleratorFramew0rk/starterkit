# Prerequisites

In order to start deploying your landing zones, you need an Azure subscription (Trial, MSDN, etc.) and you need to install the following components on your machine:
- Visual Studio Code
- Docker Desktop.
- Git
Once installed, open Visual Studio Code and install "Remote Development" extension

## Cloning the starter repository

- Download the repo as a zip file.
- Open working folder with Visual Studio Code (Note: Reopen in container when prompt in VS Code)
- (if required) Install VS Code Extension - Dev Containers
- Add a zsh terminal from VS Code

# Deploy the starter kit
## Login to Azure

```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account
```


## Step 0 - ** OPTIONAL (for non-gcc environment only)
** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 

```bash
cd /tf/avm/gcc_starter_kit/0-setup_gcc_dev_env

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

## Step 1 - create launchpad storage account and containers

- set prefix and configuration
- modify /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml according to your vnet and subnet requirements


```bash
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

# goto launchpad folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad

# create launchpad storage account
./scripts/import.sh 
```

## Step 2 - landing zone and networking

```bash
# goto landing zone folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones

# application landing zone
./deploy_application_landingzone_script.sh
```

## Step 3 - solution accelerators

```bash
# goto solution accelerators folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators

# application iot architype - iot hub, stream analytics, event hub data explorer, sql server, function app, app services etc...
./deploy_pattern_iot_archetype_script.sh

# devops service - runner container instance (if required)
./deploy_pattern_devops_runner_script.sh
```

