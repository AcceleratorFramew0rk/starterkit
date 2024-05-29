# management - bastion host
cd /tf/avm/{{gcc_starter_kit}}/landingzone/configuration/2-solution_accelerators/management/bastion_host

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-management-bastionhost.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

# management - tooling server
cd /tf/avm/{{gcc_starter_kit}}/landingzone/configuration/2-solution_accelerators/management/vm

terraform init  -reconfigure \
-backend-config="resource_group_name={{resource_group_name}}" \
-backend-config="storage_account_name={{storage_account_name}}" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-management-vm.tfstate"

terraform plan \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"

terraform apply -auto-approve \
-var="storage_account_name={{storage_account_name}}" \
-var="resource_group_name={{resource_group_name}}"




