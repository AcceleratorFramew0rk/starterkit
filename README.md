# Starterkit
Starter kit based on Accelerator Framework and allows you to create resources on Microsoft Azure in an Azure subscription. 
This is customized to install in a specific environment setup. 

# Prerequisites
In order to start deploying your landing zones, you need an Azure subscription (Trial, MSDN, etc.) and you need to install the following components on your machine:

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker Desktop](https://docs.docker.com/docker-for-windows/install/).
- [Git](https://git-scm.com/downloads)

Once installed, open **Visual Studio Code** and install "**Remote Development**" extension

# Cloning the starter repository

The starter repository contains the basic configuration files and scenarios. It will allow you to compose your configuration files in the integrated environment.
Clone the repository using the following command:

```bash
git clone https://github.com/AcceleratorFramew0rk/starterkit.git
```
OR

Download the repo as a zip file.

* Open working folder with Visual Studio Code (Note: Reopen in container when prompt in VS Code)
  * (if required) Install VS Code Extension - Dev Containers
* Add a zsh terminal from VS Code
* Follow the steps in README.md file
  
# Deploy the starter kit
## Login to Azure
```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"
```

## ** OPTIONAL: Setup GCC Simulator Environment (if required for testing and non gcc environment)
```bash
cd /tf/avm/gcc_starter_kit/0-setup_gcc_dev_env
terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

## Deploy Archetype via script

- Open an **zsh** terminal from your visual studio code.

### 1. AKS Architype [[architecture diagram](./docs/aks_archetype.md)]

```bash
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

## Edit your configuration in **config.yaml** file "/tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml"

# 1. launchpad
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad
./scripts/import.sh

# 2. application landing zone
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones
./deploy_application_landingzone.sh

# 3. solution accelerators
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
./deploy_pattern_aks_architype.sh
```

### 2. App Service Architype [[architecture diagram](./docs/appservice_archetype.md)]
```bash
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

## Edit your configuration in **config.yaml** file "/tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml"

# 1. launchpad
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad
./scripts/import.sh

# 2. application landing zone
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones
./deploy_application_landingzone.sh

# 3. solution accelerators
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
./deploy_pattern_appservice_internet_intranet_architype.sh
```


### 3. IoT Architype [[architecture diagram](./docs/iot_archetype.md)]
```bash
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

## Edit your configuration in **config.yaml** file "/tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml"

# 1. launchpad
cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad
./scripts/import.sh

# 2. application landing zone
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones
./deploy_application_landingzone.sh

# 3. solution accelerators
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
./deploy_pattern_iot_architype.sh
```


## To continue with detail of each solution accelerators, goto README.md file /tf/avm/gcc_starter_kit/README.md
```bash
cd /tf/avm/gcc_starter_kit
```
* Follow the steps in README.md file
