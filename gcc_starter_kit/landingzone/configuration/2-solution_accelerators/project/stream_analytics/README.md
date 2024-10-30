cd /tf/avm/gcc_starter_kit/landingzone/configuration/2-solution_accelerators/project/stream_analytics

terraform init  -reconfigure \
-backend-config="resource_group_name=uatlite-rg-launchpad" \
-backend-config="storage_account_name=uatlitestgtfstate3a9" \
-backend-config="container_name=2-solution-accelerators" \
-backend-config="key=solution_accelerators-project-streamanalytics.tfstate"

terraform plan \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=uatlitestgtfstate3a9" \
-var="resource_group_name=uatlite-rg-launchpad"

# Approved via Azure CLI
az network private-endpoint-connection approve \
  --id /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Devices/IotHubs/{iot-hub-name}/privateEndpointConnections/{private-connection-name} \
  --description "Approving private endpoint for Stream Analytics"