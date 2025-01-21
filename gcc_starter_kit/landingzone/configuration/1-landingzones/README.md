<!-- # goto nsg configuration folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/scripts
<!-- 
sudo chmod -R -f 777 /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/scripts

# create nsg yaml file from nsg csv files
python3 csv_to_yaml.py 

# replace subnet cidr range from config.yaml file in launchpad
./replace.sh --> -->

# goto landing zone folder
cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones

# platform landing zone
# ./deploy_platform_landingzone.sh
# or
./deploy_platform_landingzone_script.sh

# application landing zone
# ./deploy_application_landingzone.sh
# or
./deploy_application_landingzone_script.sh


# to continue, goto README.md under the folder /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators
