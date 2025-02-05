#!/bin/bash
# Source the prompt.sh file to include its functions and variables
# source ./prompt.sh

# Now you can access variables like PREFIX, VNET_PROJECT_NAME, and VNET_DEVOPS_NAME
echo "Using values from prompt.sh:"
echo "PREFIX: $PREFIX"
echo "VNET PROJECT NAME: $VNET_PROJECT_NAME"
echo "VNET DEVOPS NAME: $VNET_DEVOPS_NAME"
echo "SETTINGS YAML FILE PATH: $SETTINGS_YAML_FILE_PATH"
echo "LANDINGZONE TYPE: $LANDINGZONE_TYPE"


# Additional installation steps can go here
echo "Running installation with the above configuration..."

#------------------------------------------------------------------------
# functions
#------------------------------------------------------------------------
get_vnet_cidr() {
  local resourcegroup=$1
  local vnetname=$2

  # Query the CIDR (address prefixes) of the virtual network
  vnet_cidr=$(az network vnet show \
    --resource-group "$resourcegroup" \
    --name "$vnetname" \
    --query "addressSpace.addressPrefixes[0]" \
    --output tsv)

  # Output the retrieved CIDR
  echo "$vnet_cidr"
}
#------------------------------------------------------------------------
# end functions
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# Prepare the environment
#------------------------------------------------------------------------

# Variables for the resource group
RESOURCE_GROUP="GCCI-Platform"

if [[ "$LANDINGZONE_TYPE" == "application" || "$LANDINGZONE_TYPE" == "1" ]]; then
  
  echo "LANDINGZONE_TYPE is equal to 'application'."

  # Variables for GCCI Project VNet

  VNET_NAME=$VNET_PROJECT_NAME

  # Call the function and capture the output
  GCCI_VNET_PROJECT_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_NAME")

  # Output the retrieved CIDR
  echo "The CIDR of the GCCI Project Virtual Network is: $GCCI_VNET_PROJECT_CIDR"

  # Variables for GCCI DevOps VNet
  VNET_NAME=$VNET_DEVOPS_NAME

  # Call the function and capture the output
  GCCI_VNET_DEVOPS_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_NAME")

  # Output the retrieved CIDR
  echo "The CIDR of the GCCI DevOps Virtual Network is: $GCCI_VNET_DEVOPS_CIDR"

else
  
  echo "LANDINGZONE_TYPE is not equal to 'application'."

  # hard coded values for the virtual networks for hub and management
  VNET_HUB_INGRESS_INTERNET_NAME="gcci-vnet-ingress-internet"
  VNET_HUB_EGRESS_INTERNET_NAME="gcci-vnet-egress-internet"
  VNET_HUB_INGRESS_INTRANET_NAME="gcci-vnet-ingress-intranet"
  VNET_HUB_EGRESS_INTRANET_NAME="gcci-vnet-egress-intranet"
  VNET_MANAGEMENT_NAME="gcci-vnet-management"

  VNET_HUB_INGRESS_INTERNET_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_HUB_INGRESS_INTERNET_NAME")
  VNET_HUB_EGRESS_INTERNET_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_HUB_EGRESS_INTERNET_NAME")
  VNET_HUB_INGRESS_INTRANET_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_HUB_INGRESS_INTRANET_NAME")
  VNET_HUB_EGRESS_INTRANET_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_HUB_EGRESS_INTRANET_NAME")
  VNET_MANAGEMENT_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_MANAGEMENT_NAME")

  echo "The CIDR of the GCCI VNET HUB_INGRESS INTERNET Virtual Network is: $VNET_HUB_INGRESS_INTERNET_CIDR"
  echo "The CIDR of the GCCI VNET HUB EGRESS INTERNET Virtual Network is: $VNET_HUB_EGRESS_INTERNET_CIDR"
  echo "The CIDR of the GCCI VNET HUB INGRESS INTRANET Virtual Network is: $VNET_HUB_INGRESS_INTRANET_CIDR"
  echo "The CIDR of the GCCI VNET HUB EGRESS INTERNET Virtual Network is: $VNET_HUB_EGRESS_INTRANET_CIDR"
  echo "The CIDR of the GCCI VNET MANAGEMENT Virtual Network is: $VNET_MANAGEMENT_CIDR"

fi


