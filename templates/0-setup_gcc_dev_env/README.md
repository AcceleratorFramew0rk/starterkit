cd /tf/avm/gcc_starter_kit/0-setup_gcc_dev_env

# ** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
