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
```

## To continue, goto README.md file /tf/avm/gcc_starter_kit/README.md
```bash
cd /tf/avm/gcc_starter_kit
```
* Follow the steps in README.md file
