cd /tf/avm/{{gcc_starter_kit}}/landingzone/configuration/1-landingzones/yaml_nsg_config

sudo chmod -R -f 777 /tf/avm/{{gcc_starter_kit}}/landingzone/configuration/1-landingzones/yaml_nsg_config

python3 csv_to_yaml.py 

./replace.sh

