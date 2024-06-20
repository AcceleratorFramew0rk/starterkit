
# 0.0.4 (TBD)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.1

## FEATURES:
* 

## ENHANCEMENTS:
* add global settings tags to all solution accelerators, 0-setup_gcc_dev_env
* add intranet egress firewall
* add intranet ingress agw
* add intranet ingress firewall
* set custom module source to "AcceleratorFramew0rk/aaf/azurerm//modules/..."
* remove hardcoding of virtual network name during import of terraform state in launchpad
* remove un-used template folder to avoid duplication of codes

## BUG FIXES:
* apim - verify environment to set to either Non Production [Developer1] or Production [Premium] sku
* network - hub intranet egress - remove non valid diagnostics setting for public ip
* ingress firewall - fixed duplicate resource_group_name variable

# 0.0.3 (13 Jun 2024)
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


