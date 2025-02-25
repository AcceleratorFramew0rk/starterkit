


import csv
import sys
import os
import yaml
import ipaddress
from jinja2 import Environment, FileSystemLoader, select_autoescape


def get_config(input, solution_accelerator, landingzone_type):
    """
    Generate configuration details for a given architecture type and VNet CIDR blocks.

    Parameters:
        input (str): prefix and vnets detail.
        solution_accelerator (str): solution accelerator selection.
    Returns:
        dict: Configuration mapping for the architecture type.
    """

    # default architype = "type7"
    if landingzone_type == "application" or landingzone_type == "1":
        architype = "type7" # custom solution accelerator
    else:
        architype = "type1" # infra landing zone hub and management

    subscription_id = input.get("subscription_id")
    tenant_id = "00000000-0000-0000-0000-000000000000"
    prefix = input.get("prefix")
    environment = input.get("environment")

    project_vnet_cidr = input.get("vnets").get("project").get("cidr")
    devops_vnet_cidr = input.get("vnets").get("devops").get("cidr")
    internet_ingress_vnet_cidr = input.get("vnets").get("hub_ingress_internet").get("cidr")
    internet_egress_vnet_cidr = input.get("vnets").get("hub_egress_internet").get("cidr")
    intranet_ingress_vnet_cidr = input.get("vnets").get("hub_ingress_intranet").get("cidr")
    intranet_egress_vnet_cidr = input.get("vnets").get("hub_egress_intranet").get("cidr")
    management_vnet_cidr = input.get("vnets").get("management").get("cidr")

    project_vnet_name = input.get("vnets").get("project").get("name")
    devops_vnet_name = input.get("vnets").get("devops").get("name")
    internet_ingress_vnet_name = input.get("vnets").get("hub_ingress_internet").get("name")
    internet_egress_vnet_name = input.get("vnets").get("hub_egress_internet").get("name")
    intranet_ingress_vnet_name = input.get("vnets").get("hub_ingress_intranet").get("name")
    intranet_egress_vnet_name = input.get("vnets").get("hub_egress_intranet").get("name")
    management_vnet_name = input.get("vnets").get("management").get("name")


    print(architype) 
    print(subscription_id) 
    print(prefix) 
    print(environment) 

    print(project_vnet_cidr) 
    print(devops_vnet_cidr) 
    print(internet_ingress_vnet_cidr) 
    print(internet_egress_vnet_cidr) 
    print(intranet_ingress_vnet_cidr) 
    print(intranet_egress_vnet_cidr) 
    print(management_vnet_cidr) 

    print(project_vnet_name) 
    print(devops_vnet_name) 
    print(internet_ingress_vnet_name) 
    print(internet_egress_vnet_name) 
    print(intranet_ingress_vnet_name) 
    print(intranet_egress_vnet_name) 
    print(management_vnet_name) 




    # --- Added Logic for Subnet Address Prefixes ---
    SystemNodePoolSubnet_address_prefixes = ""
    UserNodePoolSubnet_address_prefixes = ""
    UserNodePoolIntranetSubnet_address_prefixes = ""
    AiSubnet_address_prefixes = ""
    AppServiceSubnet_address_prefixes = ""
    ServiceSubnet_address_prefixes = ""              
    DbSubnet_address_prefixes = ""
    WebSubnet_address_prefixes = ""
    AppSubnet_address_prefixes = ""    
    FunctionAppSubnet_address_prefixes = ""
    ApiSubnet_address_prefixes = ""
    CiSubnet_address_prefixes = ""
    LogicAppSubnet_address_prefixes = ""
    ServiceBusSubnet_address_prefixes = ""    
    ServiceBusSubnet_address_prefixes = ""    
    CosmosDbSubnet_address_prefixes = ""        
    RunnerSubnet_address_prefixes = ""
    WebIntranetSubnet_address_prefixes = ""
    AppServiceIntranetSubnet_address_prefixes = ""
    RedisCacheSubnet_address_prefixes = ""
    ContainerAppSubnet_address_prefixes = ""
    ContainerAppIntranetSubnet_address_prefixes = ""
    config_yaml = ""
    config_yaml_encoded = ""
    internet_ingress_subnets = ""
    internet_egress_subnets = ""
    intranet_ingress_subnets = ""
    intranet_egress_subnets = ""
    management_subnets = ""
    project_subnets = ""
    devops_subnets = ""
    subnets = ""
    hub_internet_ingress_AzureFirewallSubnet_address_prefixes = ""
    hub_internet_ingress_AgwSubnet_address_prefixes = ""
    hub_internet_egress_AzureFirewallSubnet_address_prefixes = ""
    hub_internet_egress_AzureFirewallManagementSubnet_address_prefixes = ""
    hub_intranet_ingress_AzureFirewallSubnet_address_prefixes = ""
    hub_intranet_ingress_AgwSubnet_address_prefixes = ""
    hub_intranet_egress_AzureFirewallSubnet_address_prefixes = ""
    hub_intranet_egress_AzureFirewallManagementSubnet_address_prefixes = ""
    management_InfraSubnet_address_prefixes = ""
    management_SecuritySubnet_address_prefixes = ""
    management_AzureBastionSubnet_address_prefixes = ""


    if architype == "type1":

        subnet_prefix_length = 26 # 64 IP Addresses
        management_subnet_prefix_length = 27

        # Reset unused VNet CIDRs for this architecture
        project_vnet_cidr = ""
        devops_vnet_cidr = ""

        # Validate and parse CIDR inputs for type1 architecture
        internet_ingress_vnet = validate_cidr(internet_ingress_vnet_cidr, "internet_ingress_vnet_cidr")
        internet_egress_vnet = validate_cidr(internet_egress_vnet_cidr, "internet_egress_vnet_cidr")
        intranet_ingress_vnet = validate_cidr(intranet_ingress_vnet_cidr, "intranet_ingress_vnet_cidr")
        intranet_egress_vnet = validate_cidr(intranet_egress_vnet_cidr, "intranet_egress_vnet_cidr")
        management_vnet = validate_cidr(management_vnet_cidr, "management_vnet_cidr")

        # Split VNets into smaller subnets
        internet_ingress_subnets = list(internet_ingress_vnet.subnets(new_prefix=subnet_prefix_length))
        internet_egress_subnets = list(internet_egress_vnet.subnets(new_prefix=subnet_prefix_length))
        intranet_ingress_subnets = list(intranet_ingress_vnet.subnets(new_prefix=subnet_prefix_length))
        intranet_egress_subnets = list(intranet_egress_vnet.subnets(new_prefix=subnet_prefix_length))
        management_subnets = list(management_vnet.subnets(new_prefix=management_subnet_prefix_length))

        # Assign specific subnets
        hub_internet_ingress_AzureFirewallSubnet_address_prefixes = str(internet_ingress_subnets[0])
        hub_internet_ingress_AgwSubnet_address_prefixes = str(internet_ingress_subnets[1])
        hub_internet_egress_AzureFirewallSubnet_address_prefixes = str(internet_egress_subnets[0])
        hub_internet_egress_AzureFirewallManagementSubnet_address_prefixes = str(internet_egress_subnets[1])
        hub_intranet_ingress_AzureFirewallSubnet_address_prefixes = str(intranet_ingress_subnets[0])
        hub_intranet_ingress_AgwSubnet_address_prefixes = str(intranet_ingress_subnets[1])
        hub_intranet_egress_AzureFirewallSubnet_address_prefixes = str(intranet_egress_subnets[0])
        hub_intranet_egress_AzureFirewallManagementSubnet_address_prefixes = str(intranet_egress_subnets[1])
        management_InfraSubnet_address_prefixes = str(management_subnets[0])
        management_SecuritySubnet_address_prefixes = str(management_subnets[1])
        management_AzureBastionSubnet_address_prefixes = str(management_subnets[2])

    if architype == "type2" or architype == "type3" or architype == "type4" or architype == "type5" or architype == "type6" or architype == "type7": 
        
        # Define the desired subnet prefix length
        # Adjust the prefix length as needed (e.g., /24 for 256 IPs per subnet)
        subnet_prefix_length = 27
        devops_subnet_prefix_length = 27

        # init the ingress/egress, management vnets to nothing
        internet_ingress_vnet_cidr = ""
        internet_egress_vnet_cidr = ""
        intranet_ingress_vnet_cidr = ""
        intranet_egress_vnet_cidr = ""
        management_vnet_cidr = ""

        project_vnet = validate_cidr(project_vnet_cidr, "project_vnet_cidr")
        devops_vnet = validate_cidr(devops_vnet_cidr, "devops_vnet_cidr")

        # Split the project VNet into subnets of the desired size
        subnets = list(project_vnet.subnets(new_prefix=subnet_prefix_length))
        devops_subnets = list(devops_vnet.subnets(new_prefix=devops_subnet_prefix_length))

        # Ensure there are enough subnets available
        required_subnets = 8  # As per your requirements
        required_devops_subnets = 2  # As per your requirements
        if len(subnets) < required_subnets:
            raise ValueError(f"Not enough subnets available in {project_vnet_cidr} to allocate {required_subnets} subnets with prefix /{subnet_prefix_length}")

        if len(devops_subnets) < required_devops_subnets:
            raise ValueError(f"Not enough subnets available in {devops_vnet_cidr} to allocate {required_devops_subnets} subnets with prefix /{devops_subnet_prefix_length}")

        if architype == "type2": 
            # Assign each subnet
            WebSubnet_address_prefixes = str(subnets[0])
            AppSubnet_address_prefixes = str(subnets[1])            
            ServiceSubnet_address_prefixes = str(subnets[2])                
            DbSubnet_address_prefixes = str(subnets[3])

        if architype == "type3": 
            print(architype)
            # Assign each subnet
            SystemNodePoolSubnet_address_prefixes = str(subnets[0])
            UserNodePoolSubnet_address_prefixes = str(subnets[1])
            UserNodePoolIntranetSubnet_address_prefixes = str(subnets[2])
            AppServiceSubnet_address_prefixes = str(subnets[3])
            ServiceSubnet_address_prefixes = str(subnets[4])  
            DbSubnet_address_prefixes = str(subnets[5])

        if architype == "type4": 
            # Assign each subnet
            WebSubnet_address_prefixes = str(subnets[0])
            AppServiceSubnet_address_prefixes = str(subnets[1])
            ServiceSubnet_address_prefixes = str(subnets[2])                
            DbSubnet_address_prefixes = str(subnets[3])

        if architype == "type5": 
            # Assign each subnet
            WebSubnet_address_prefixes = str(subnets[0])
            FunctionAppSubnet_address_prefixes = str(subnets[1])
            ApiSubnet_address_prefixes = str(subnets[2])
            AppServiceSubnet_address_prefixes = str(subnets[3])
            ServiceSubnet_address_prefixes = str(subnets[4])                
            DbSubnet_address_prefixes = str(subnets[5])

        if architype == "type6": 
            # Assign each subnet (/24 max 8 cidr of 32 ip /27)
            WebSubnet_address_prefixes = str(subnets[0])
            AppSubnet_address_prefixes = str(subnets[1])            
            FunctionAppSubnet_address_prefixes = str(subnets[2])
            ApiSubnet_address_prefixes = str(subnets[3])
            AppServiceSubnet_address_prefixes = str(subnets[4])
            AiSubnet_address_prefixes = str(subnets[5])
            ServiceSubnet_address_prefixes = str(subnets[6])                
            DbSubnet_address_prefixes = str(subnets[7])            

        if architype == "type7": 

            # Load settings YAML content
            solution_accelerator_data = solution_accelerator 

            # service subnet is always needed 
            ServiceSubnet_address_prefixes = str(subnets[0])   

            # Retrieve the value of ACR
            count = 1
  
            # current_value = solution_accelerator_data.get("project", {}).get("acr", None)
            current_value = solution_accelerator_data.get("project", {}).get("acr") or solution_accelerator_data.get("project", {}).get("acr_avm")
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("ai_foundry_enterprise", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AiSubnet_address_prefixes == "":
                    AiSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("aks_avm_ptn", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if SystemNodePoolSubnet_address_prefixes == "":
                    SystemNodePoolSubnet_address_prefixes = str(subnets[count])
                    count = count + 1
                if UserNodePoolSubnet_address_prefixes == "":
                    UserNodePoolSubnet_address_prefixes = str(subnets[count])
                    count = count + 1
                if UserNodePoolIntranetSubnet_address_prefixes == "":
                    UserNodePoolIntranetSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("apim", None) or solution_accelerator_data.get("project", {}).get("apim_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ApiSubnet_address_prefixes == "":
                    ApiSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("app_service", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AppServiceSubnet_address_prefixes == "":
                    AppServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1
                if WebSubnet_address_prefixes == "":
                    WebSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("app_service_intranet", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AppServiceIntranetSubnet_address_prefixes == "":
                    AppServiceIntranetSubnet_address_prefixes = str(subnets[count])
                    count = count + 1
                if WebIntranetSubnet_address_prefixes == "":
                    WebIntranetSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("app_service_windows", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AppServiceSubnet_address_prefixes == "":
                    AppServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1
                if WebSubnet_address_prefixes == "":
                    WebSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("azure_open_ai", None) or solution_accelerator_data.get("project", {}).get("azure_open_ai_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AiSubnet_address_prefixes == "":
                    AiSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("container_instance", None) or solution_accelerator_data.get("project", {}).get("container_instance_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if CiSubnet_address_prefixes == "":
                    CiSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("cosmos_db_mongo", None) or solution_accelerator_data.get("project", {}).get("cosmos_db_mongo_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if CosmosDbSubnet_address_prefixes == "":
                    CosmosDbSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("cosmos_db_sql", None) or solution_accelerator_data.get("project", {}).get("cosmos_db_sql_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if CosmosDbSubnet_address_prefixes == "":
                    CosmosDbSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("data_explorer", None) or solution_accelerator_data.get("project", {}).get("data_explorer_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("event_hubs", None) or solution_accelerator_data.get("project", {}).get("event_hubs_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("iot_hub", None) or solution_accelerator_data.get("project", {}).get("iot_hub_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("keyvault", None) or solution_accelerator_data.get("project", {}).get("keyvault_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("linux_function_app", None) or solution_accelerator_data.get("project", {}).get("linux_function_app_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if FunctionAppSubnet_address_prefixes == "":
                    FunctionAppSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("logic_app", None) or solution_accelerator_data.get("project", {}).get("logic_app_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if LogicAppSubnet_address_prefixes == "":
                    LogicAppSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("mssql", None) or solution_accelerator_data.get("project", {}).get("mssql_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if DbSubnet_address_prefixes == "":
                    DbSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("redis_cache", None) or solution_accelerator_data.get("project", {}).get("redis_cache_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if RedisCacheSubnet_address_prefixes == "":
                    RedisCacheSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("search_service", None) or solution_accelerator_data.get("project", {}).get("search_service_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("service_bus", None) or solution_accelerator_data.get("project", {}).get("service_bus_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceBusSubnet_address_prefixes == "":
                    ServiceBusSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("storage_account", None) or solution_accelerator_data.get("project", {}).get("storage_account_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("stream_analytics", None) or solution_accelerator_data.get("project", {}).get("stream_analytics_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ServiceSubnet_address_prefixes == "":
                    ServiceSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("vm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AppSubnet_address_prefixes == "":
                    AppSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("container_app", None) or solution_accelerator_data.get("project", {}).get("container_app_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ContainerAppSubnet_address_prefixes == "":
                    ContainerAppSubnet_address_prefixes = str(subnets[count])
                    count = count + 1
                if WebSubnet_address_prefixes == "":
                    WebSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("container_app_intranet", None) or solution_accelerator_data.get("project", {}).get("container_app_intranet_avm", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if ContainerAppIntranetSubnet_address_prefixes == "":
                    ContainerAppIntranetSubnet_address_prefixes = str(subnets[count])
                    count = count + 1  
                if WebIntranetSubnet_address_prefixes == "":
                    WebIntranetSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("vmss_linux", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AppSubnet_address_prefixes == "":
                    AppSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

            current_value = solution_accelerator_data.get("project", {}).get("vmss_windows", None)
            print(current_value)
            if current_value == 'True' or current_value is True or current_value == 'true' :
                if AppSubnet_address_prefixes == "":
                    AppSubnet_address_prefixes = str(subnets[count])
                    count = count + 1

        # devops
        RunnerSubnet_address_prefixes = str(devops_subnets[0]) 
            
    cidr_mappings = {
        "subscription_id": subscription_id,
        "tenant_id": tenant_id,
        "prefix": prefix,
        "environment": environment,
        # application landign zone
        "project_vnet_cidr": project_vnet_cidr,
        "devops_vnet_cidr": devops_vnet_cidr,
        "DbSubnet_address_prefixes": DbSubnet_address_prefixes,
        "CosmosDbSubnet_address_prefixes": CosmosDbSubnet_address_prefixes,
        "ServiceSubnet_address_prefixes": ServiceSubnet_address_prefixes,
        "SystemNodePoolSubnet_address_prefixes": SystemNodePoolSubnet_address_prefixes,
        "UserNodePoolSubnet_address_prefixes": UserNodePoolSubnet_address_prefixes,
        "UserNodePoolIntranetSubnet_address_prefixes": UserNodePoolIntranetSubnet_address_prefixes,
        "AiSubnet_address_prefixes": AiSubnet_address_prefixes,
        "CiSubnet_address_prefixes": CiSubnet_address_prefixes,
        "LogicAppSubnet_address_prefixes": LogicAppSubnet_address_prefixes,
        "AppServiceSubnet_address_prefixes": AppServiceSubnet_address_prefixes,
        "WebSubnet_address_prefixes": WebSubnet_address_prefixes,
        "AppSubnet_address_prefixes": AppSubnet_address_prefixes,
        "FunctionAppSubnet_address_prefixes": FunctionAppSubnet_address_prefixes,
        "ApiSubnet_address_prefixes": ApiSubnet_address_prefixes,
        "LogicAppSubnet_address_prefixes": LogicAppSubnet_address_prefixes,
        "ServiceBusSubnet_address_prefixes": ServiceBusSubnet_address_prefixes,
        "AiSubnet_address_prefixes": AiSubnet_address_prefixes,
        "WebIntranetSubnet_address_prefixes": WebIntranetSubnet_address_prefixes,
        "AppServiceIntranetSubnet_address_prefixes": AppServiceIntranetSubnet_address_prefixes,
        "ContainerAppSubnet_address_prefixes": ContainerAppSubnet_address_prefixes,
        "ContainerAppIntranetSubnet_address_prefixes": ContainerAppIntranetSubnet_address_prefixes,
        "RunnerSubnet_address_prefixes": RunnerSubnet_address_prefixes,
        # infra landing zone
        "hub_ingress_internet_vnet_cidr": internet_ingress_vnet_cidr,
        "hub_egress_internet_vnet_cidr": internet_egress_vnet_cidr,
        "hub_ingress_intranet_vnet_cidr": intranet_ingress_vnet_cidr,
        "hub_egress_intranet_vnet_cidr": intranet_egress_vnet_cidr,
        "management_vnet_cidr": management_vnet_cidr,
        "hub_internet_ingress_AzureFirewallSubnet_address_prefixes": hub_internet_ingress_AzureFirewallSubnet_address_prefixes,
        "hub_internet_ingress_AgwSubnet_address_prefixes": hub_internet_ingress_AgwSubnet_address_prefixes,
        "hub_internet_egress_AzureFirewallSubnet_address_prefixes": hub_internet_egress_AzureFirewallSubnet_address_prefixes,
        "hub_internet_egress_AzureFirewallManagementSubnet_address_prefixes": hub_internet_egress_AzureFirewallManagementSubnet_address_prefixes,
        "hub_intranet_ingress_AzureFirewallSubnet_address_prefixes": hub_intranet_ingress_AzureFirewallSubnet_address_prefixes,
        "hub_intranet_ingress_AgwSubnet_address_prefixes": hub_intranet_ingress_AgwSubnet_address_prefixes,
        "hub_intranet_egress_AzureFirewallSubnet_address_prefixes": hub_intranet_egress_AzureFirewallSubnet_address_prefixes,
        "hub_intranet_egress_AzureFirewallManagementSubnet_address_prefixes": hub_intranet_egress_AzureFirewallManagementSubnet_address_prefixes,
        "management_InfraSubnet_address_prefixes": management_InfraSubnet_address_prefixes,
        "management_SecuritySubnet_address_prefixes": management_SecuritySubnet_address_prefixes,
        "management_AzureBastionSubnet_address_prefixes": management_AzureBastionSubnet_address_prefixes,
    }


    # Step 4: Apply the replacement and save the result
    config_yaml = render_config_yaml("template.jinja", cidr_mappings)

    return config_yaml

def validate_cidr(cidr, name):
    """
    Validate a CIDR block and return it as an IPv4 network object.
    """
    try:
        return ipaddress.ip_network(cidr)
    except ValueError as e:
        raise ValueError(f"Invalid {name}: {e}")


def validate_subnet_count(subnets, required, cidr, prefix_length):
    """
    Ensure the number of available subnets meets the required count.
    """
    if len(subnets) < required:
        raise ValueError(
            f"Not enough subnets available in {cidr} to allocate {required} subnets with prefix /{prefix_length}"
        )


# utils.py
def render_config_yaml(template_name: str, context: dict):
    # Set up the Jinja2 environment

    print(os.getcwd())

    env = Environment(
        loader=FileSystemLoader(searchpath="./../templates"),
        autoescape=select_autoescape(['jinja', 'html', 'xml'])
    )

    # Load the template
    template = env.get_template(template_name)

    print(template)

    # Render the template with the context
    rendered_content = template.render(context)

    return rendered_content

def save_yaml(content, output_path):
    with open(output_path, 'w') as file:
        yaml.dump(content, file)


def main():

    # Ensure the script is called with the YAML file path as an argument
    if len(sys.argv) < 2:
        print("Usage: python3 render_config.py <settings_yaml_file_path> <landingzone_type>")
        sys.exit(1)

    # Path to the YAML file
    input_yaml_file_path = './../config/input.yaml' # '/tf/avm/scripts/input.yaml'
    solution_accelerator_yaml_file_path =  sys.argv[1] # '/tf/avm/scripts/settings.yaml'

    landingzone_type =  sys.argv[2] # application or infrastrucutre'
    print("landingzone type: ", landingzone_type)
    if landingzone_type not in ["application", "infrastructure", "1", "2"]:
        print("Usage: python3 render_config.py <settings_yaml_file_path> <landingzone_type>")
        sys.exit(1)

    if landingzone_type == "1":
        landingzone_type = "application"

    # Read and parse the YAML file
    with open(input_yaml_file_path, 'r') as file:
        input_config = yaml.safe_load(file)

    # Read and parse the YAML file
    with open(solution_accelerator_yaml_file_path, 'r') as file1:
        solution_accelerator = yaml.safe_load(file1)

    config_yaml = get_config(input_config, solution_accelerator, landingzone_type)

    print(config_yaml)

    # Open the file in write mode ('w') and print to it
    with open('./../config/output_config.yaml', 'w') as file:
        print(config_yaml, file=file)

  
if __name__ == '__main__':
    main()