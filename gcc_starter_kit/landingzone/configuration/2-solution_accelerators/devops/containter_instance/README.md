cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/devops/containter_instance


# default image is gccstarterkit/gccstarterkit-avm-sde:0.1

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-devops-container-instance.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"


NOTE: Container Instance does not have Diagnostic Settings
