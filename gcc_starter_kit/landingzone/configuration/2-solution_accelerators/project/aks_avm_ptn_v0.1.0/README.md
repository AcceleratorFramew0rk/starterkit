#!/bin/bash

# Extract the value of 'prefix' using yq and assign it to the PREFIX variable and generate resource group name to store state file

PREFIX=$(yq  -r '.prefix' /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/scripts/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX//-/}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
echo $RG_NAME
echo $STG_NAME

# deploy the solution accelerator

cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-aksptn.tfstate"

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

# ----------------------------------------------------------------------------------------

# NOTE: SystemNodePoolSubnet required NAT Gateway

# Estimate time: 20 minutes to deploy
system node: 10 minutes
diagnostic setting 20 seconds
user node: 10 minutes

# 04 Jun 2024
# if egress firewall is not deployed, make sure do not create the route table
# Solution - ensure routetable is set correctly or remove it.
<!-- │ Error: creating Kubernetes Cluster (Subscription: "0b5b13b8-0ad7-4552-936f-8fae87e0633f"
│ Resource Group Name: "aoaidev-rg-solution-accelerators-aks"
│ Kubernetes Cluster Name: "aks-aoaidev-aks-ran"): polling after CreateOrUpdate: polling failed: the Azure API returned the following error:
│ 
│ Status: "VMExtensionProvisioningError"
│ Code: ""
│ Message: "Unable to establish outbound connection from agents, please see https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/error-code-outboundconnfailvmextensionerror and https://aka.ms/aks-required-ports-and-addresses for more information."
│ Activity Id: "" -->

# ** IMPORTANT: ensure subnet has sufficient IPs available for the worker nodes (max count)

# ** IMPORTANT: remove deny all inbound and outbound to test if AKS create failed for SystemNodePoolSubnet and UserNodePoolSubnet NSG
