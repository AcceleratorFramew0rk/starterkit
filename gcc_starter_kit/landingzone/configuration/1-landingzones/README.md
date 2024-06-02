# goto nsg configuration folder
cd /tf/avm/{{gcc_starter_kit}}/landingzone/configuration/1-landingzones/nsg

sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/yaml_nsg_config

# create nsg yaml file from nsg csv files
python3 csv_to_yaml.py 

# replace subnet cidr range from config.yaml file in launchpad
./replace.sh

# goto landing zone folder
cd /tf/avm/{{gcc_starter_kit}}/landingzone/configuration/1-landingzones

# platform landing zone
./deploy_platform_landingzone.sh

# application landing zone
./deploy_application_landingzone.sh

# to continue, goto README.md under the folder /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
