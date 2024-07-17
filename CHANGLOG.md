# 0.0.7 (TBD)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.5

## FEATURES:
* 

## ENHANCEMENTS:
* 

## BUG FIXES:
* 
  
# 0.0.6 (17 Jul 2024)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.5

## FEATURES:
* add logs and backup to solution accelerator app service

## ENHANCEMENTS:
* change subnets creation using avm "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"

## BUG FIXES:
* fixed cosmos db mongo deploy error
* fixed cosmos db sql deploy error

# 0.0.5 (10 Jul 2024)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.4

## FEATURES:
* add launchpad for non gcc env with creation of virtual networks
* add logic app solution accelerators

## ENHANCEMENTS:
* remove modules from starter kit. all non avm modules exists in aaf
* allow to set the source_image_resource_id for vm solution accelerator
* gcc dev env to accept variables via -var in terraform plan/apply
* rename script_launchpad to script
* upgrade avm virtual networks to version = "0.2.3"
* upgrade avm private dns zone to version = "0.1.2"

## BUG FIXES:
* fix [This object does not have an attribute named "resource"] keyvault resource_id error for management vm

# 0.0.4 (20 Jun 2024)
## COMPATIBLE WITH:
* aaf avm sde: gccstarterkit/gccstarterkit-avm-sde:0.1 
* azurerm: version 3.85
* aaf: 0.0.3

## FEATURES:
* add intranet egress firewall
* add intranet ingress agw
* add intranet ingress firewall

## ENHANCEMENTS:
* add global settings tags to all solution accelerators, 0-setup_gcc_dev_env
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


