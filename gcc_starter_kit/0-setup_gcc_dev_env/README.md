cd /tf/avm/gcc_starter_kit/0-setup_gcc_dev_env

# ** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 

terraform init -reconfigure
terraform plan
terraform apply -auto-approve

# to continue, goto launchpad folder and follow the steps in README.md

cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad


# OR passing variable through -var to terraform plan/apply

# platform landing zone and application landing zone is seperate subscription


# platform landing zone virtual networks ONLY
terraform init -reconfigure

terraform plan \
-var="vnets_hub_ingress_internet_name=gcci-vnet-ingress-internet" \
-var="vnets_hub_ingress_internet_cidr=100.127.0.0/24" \
-var="vnets_hub_egress_internet_name=gcci-vnet-egress-internet" \
-var="vnets_hub_egress_internet_cidr=100.127.1.0/24" \
-var="vnets_hub_ingress_intranet_name=gcci-vnet-ingress-intranet" \
-var="vnets_hub_ingress_intranet_cidr=10.20.0.0/25" \
-var="vnets_hub_egress_intranet_name=gcci-vnet-egress-intranet" \
-var="vnets_hub_egress_intranet_cidr=10.20.1.0/25" \
-var="vnets_management_name=gcci-vnet-management" \
-var="vnets_management_cidr=100.127.3.0/24" 


terraform apply -auto-approve \
-var="vnets_hub_ingress_internet_name=gcci-vnet-ingress-internet" \
-var="vnets_hub_ingress_internet_cidr=100.127.0.0/24" \
-var="vnets_hub_egress_internet_name=gcci-vnet-egress-internet" \
-var="vnets_hub_egress_internet_cidr=100.127.1.0/24" \
-var="vnets_hub_ingress_intranet_name=gcci-vnet-ingress-intranet" \
-var="vnets_hub_ingress_intranet_cidr=10.20.0.0/25" \
-var="vnets_hub_egress_intranet_name=gcci-vnet-egress-intranet" \
-var="vnets_hub_egress_intranet_cidr=10.20.1.0/25" \
-var="vnets_management_name=gcci-vnet-management" \
-var="vnets_management_cidr=100.127.3.0/24" 

# application landing zone virtual networks ONLY
terraform init -reconfigure

terraform plan \
-var="vnets_project_name=gcci-vnet-project" \
-var="vnets_project_cidr=100.64.0.0/23" \
-var="vnets_devops_name=gcci-vnet-devops" \
-var="vnets_devops_cidr=100.127.4.0/24" 


terraform apply -auto-approve \
-var="vnets_project_name=gcci-vnet-project" \
-var="vnets_project_cidr=100.64.0.0/23" \
-var="vnets_devops_name=gcci-vnet-devops" \
-var="vnets_devops_cidr=100.127.4.0/24" 


# platform and application landing zone virtual networks TOGETHER (for testing only)
terraform init -reconfigure

terraform plan \
-var="vnets_hub_ingress_internet_name=gcci-vnet-ingress-internet" \
-var="vnets_hub_ingress_internet_cidr=100.127.0.0/24" \
-var="vnets_hub_egress_internet_name=gcci-vnet-egress-internet" \
-var="vnets_hub_egress_internet_cidr=100.127.1.0/24" \
-var="vnets_hub_ingress_intranet_name=gcci-vnet-ingress-intranet" \
-var="vnets_hub_ingress_intranet_cidr=10.20.0.0/25" \
-var="vnets_hub_egress_intranet_name=gcci-vnet-egress-intranet" \
-var="vnets_hub_egress_intranet_cidr=10.20.1.0/25" \
-var="vnets_management_name=gcci-vnet-management" \
-var="vnets_management_cidr=100.127.3.0/24" \
-var="vnets_project_name=gcci-vnet-project" \
-var="vnets_project_cidr=100.64.0.0/23" \
-var="vnets_devops_name=gcci-vnet-devops" \
-var="vnets_devops_cidr=100.127.4.0/24" 

terraform apply -auto-approve \
-var="vnets_hub_ingress_internet_name=gcci-vnet-ingress-internet" \
-var="vnets_hub_ingress_internet_cidr=100.127.0.0/24" \
-var="vnets_hub_egress_internet_name=gcci-vnet-egress-internet" \
-var="vnets_hub_egress_internet_cidr=100.127.1.0/24" \
-var="vnets_hub_ingress_intranet_name=gcci-vnet-ingress-intranet" \
-var="vnets_hub_ingress_intranet_cidr=10.20.0.0/25" \
-var="vnets_hub_egress_intranet_name=gcci-vnet-egress-intranet" \
-var="vnets_hub_egress_intranet_cidr=10.20.1.0/25" \
-var="vnets_management_name=gcci-vnet-management" \
-var="vnets_management_cidr=100.127.3.0/24" \
-var="vnets_project_name=gcci-vnet-project" \
-var="vnets_project_cidr=100.64.0.0/23" \
-var="vnets_devops_name=gcci-vnet-devops" \
-var="vnets_devops_cidr=100.127.4.0/24" 