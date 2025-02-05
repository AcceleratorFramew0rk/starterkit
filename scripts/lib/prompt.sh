#!/bin/bash

# Function to prompt for user input with default value support
prompt_for_input() {
  local prompt_message=$1
  local default_value=$2
  local user_input

  # Read input from the user
  read -rp "$prompt_message [$default_value]: " user_input

  # If input is empty, use the default value
  echo "${user_input:-$default_value}"
}

# Prompt for PREFIX, ensuring it is not empty
while true; do
  read -rp "Enter the PREFIX (required): " PREFIX
  if [[ -n "$PREFIX" ]]; then
    break
  else
    echo "PREFIX must not be empty. Please try again."
  fi
done

# Prompt for VNET Project Name with a default value
ENVIRONMENT=$(prompt_for_input "Enter the ENVIRONMENT (dev, sit, uat, prd)" "dev")

# Prompt for VNET Project Name with a default value
VNET_PROJECT_NAME=$(prompt_for_input "Enter the VNET Project Name" "gcci-vnet-project")

# Prompt for VNET DevOps Name with a default value
VNET_DEVOPS_NAME=$(prompt_for_input "Enter the VNET DevOps Name" "gcci-vnet-devops")

# Prompt for settings.yaml path with a default value
SETTINGS_YAML_FILE_PATH=$(prompt_for_input "Enter the settings.yaml path" "./../config/settings.yaml")

# Prompt for settings.yaml path with a default value
LANDINGZONE_TYPE=$(prompt_for_input "Enter the Landing Zone Type (1: application or 2: infrastructure)" "1")

# Output the collected inputs
echo "Configuration:"
echo "PREFIX: $PREFIX"
echo "ENVIRONMENT: $ENVIRONMENT"
echo "VNET PROJECT NAME: $VNET_PROJECT_NAME"
echo "VNET DEVOPS NAME: $VNET_DEVOPS_NAME"
echo "SETTINGS YAML FILE PATH: $SETTINGS_YAML_FILE_PATH"
echo "LANDINGZONE TYPE: $LANDINGZONE_TYPE"
