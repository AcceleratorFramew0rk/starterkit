variable "subnets" {
  type = map(object(
    {
      address_prefixes = list(string) # (Required) The address prefixes to use for the subnet.
      nat_gateway = optional(object({
        id = string # (Required) The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.
      }))
      network_security_group = optional(object({
        id = string # (Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.
      }))
      private_endpoint_network_policies_enabled     = optional(bool, true) # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
      private_link_service_network_policies_enabled = optional(bool, true) # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
      route_table = optional(object({
        id = string # (Required) The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created.
      }))
      service_endpoints           = optional(set(string)) # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`.
      service_endpoint_policy_ids = optional(set(string)) # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
      delegations = optional(list(
        object(
          {
            name = string # (Required) A name for this delegation.
            service_delegation = object({
              name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.
              actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
            })
          }
        )
      ))
    }
  ))
  description = "Subnets to create"
}
variable "virtual_network_name" {
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}
