sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration

cd /tf/avm/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad

./scripts/import.sh

## NOTE: to perform update of the config.yaml configuration, execute the update script below.
## ./scripts/import_update.sh
## when prompt, enter the storage_account_name

# to continue, goto README.md under the folder /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones
