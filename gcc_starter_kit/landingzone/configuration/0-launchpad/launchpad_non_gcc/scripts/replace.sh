
# Check if at least one parameter is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [prefix]"
  exit 1
fi

# Assign the first parameter to the variable 'name'
PREFIX=$1

RG_NAME=${PREFIX}-rg-launchpad
STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)

cd ./../../../configuration
pwd
echo $RG_NAME
echo $STG_NAME
sleep 5 # to allow flushing of file to disks
find . -name '*.md' -exec sed -i -e "s/{{resource_group_name}}/$RG_NAME/g" {} \;
sleep 5
find . -name '*.md' -exec sed -i -e "s/{{storage_account_name}}/$STG_NAME/g" {} \;
sleep 5
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones
find . -name '*.sh' -exec sed -i -e "s/{{resource_group_name}}/$RG_NAME/g" {} \;
sleep 5
find . -name '*.sh' -exec sed -i -e "s/{{storage_account_name}}/$STG_NAME/g" {} \;
sleep 5
cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
find . -name '*.sh' -exec sed -i -e "s/{{resource_group_name}}/$RG_NAME/g" {} \;
sleep 5
find . -name '*.sh' -exec sed -i -e "s/{{storage_account_name}}/$STG_NAME/g" {} \;
sleep 5
read -p "Press enter to continue..."