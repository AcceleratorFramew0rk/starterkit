# 0.0.3 (TBD)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.1

## FEATURES:
* standalone deployment for each solution accelerator with no dependencies to launchpad import.sh script and landing zones

## ENHANCEMENTS:
* update avm "Azure/avm-res-network-bastionhost/azurerm" to version 0.2.0
* add diagnostic settings for bastion host
* add diagnostic settings for devops container instance 
* standalone deployment for solution accelerator - mssql
* add diagnoatics settings for apim, search service, service bus, storage account

## BUG FIXES:
* fix network security group for application gateway

# 0.0.2 (May 29, 2024)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.1

## FEATURES:
* modules:
  * api management
* solution accelerators:
  * api management (apim)

## ENHANCEMENTS:
* update freamework.landingzone source to use registry.terraform.io "AcceleratorFramew0rk/aaf/azurerm" version 0.0.1
* update avm "Azure/avm-res-network-virtualnetwork/azurerm" to version 0.1.4
* update avm "Azure/avm-res-network-networksecuritygroup/azurerm" to version 0.2.0
* setup gcc dev env - convert to using config.yaml for vnet name and cidr
* add diagnostic settings for network security group for application/platform landing zone

## BUG FIXES:
* fixed networksecuritygroup output "resource" and "security_rules" invalid attributes error

# 0.0.1 (May 23, 2024)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.1

## FEATURES:
* import gcci tfstate
* platform common service landing zone
* application landing zone
* solution accelerators:
  * aks
  * sql server
  * container registry
  * app service
  * key vault
  * bastion host
  * vm
  * container instance 

## ENHANCEMENTS:

## BUG FIXES:


