# Takes a file CSV file called "data.csv" and outputs each row as a numbered YAML file.
# Data in the first row of the CSV is assumed to be the column heading.

# Import the python library for parsing CSV files.
import csv
import sys
import os
import yaml
import re

# begin function csv_to_yaml
def csv_to_yaml():
		directory = './csv'
		all_yaml = ""
		with os.scandir(directory) as entries:
				for entry in entries:
						# Check if it's a file
						if entry.is_file():
								# csv_to_yaml(entry.name)
								print(get_filename_without_extension(entry.name))		
								nsg_csv = get_filename_without_extension(entry.name) # filename
								# Open our data file in read-mode.
								inputfilenamepath = './csv/' + nsg_csv + '.csv'
								outputfilenamepath = './yaml/' + nsg_csv + '.yaml'
								# csvfile = open('./csv/{nsg_csv}.csv', 'r')
								csvfile = open(inputfilenamepath, 'r')
								yaml_file = nsg_csv + ":" + "\n"
								# Save a CSV Reader object.
								datareader = csv.reader(csvfile, delimiter=',', quotechar='"')
								# Empty array for data headings, which we will fill with the first row from our CSV.
								data_headings = []
								# Loop through each row...
								for row_index, row in enumerate(datareader):
									# If this is the first row, populate our data_headings variable.
									if row_index == 0:
										data_headings = row
									# Othrwise, create a YAML file from the data in this row...
									else:
										# Open a new file with filename based on index number of our current row.
										# Empty string that we will fill with YAML formatted text based on data extracted from our CSV.
										yaml_row_index = "nsg_" + str(row_index) + ':' + "\n"
										yaml_text = ""
										yaml_row_heading = "" 
										cell_tag = ""		
										# Loop through each cell in this row...
										for cell_index, cell in enumerate(row):
											# Compile a line of YAML text from our headings list and the text of the current cell, followed by a linebreak.
											# Heading text is converted to lowercase. Spaces are converted to underscores and hyphens are removed.
											# In the cell text, line endings are replaced with commas.
											cell_heading = data_headings[cell_index].lower().replace(" ", "").replace("-", "")
											cell_tag = ""
											# Add this line of text to the current YAML string.
											if cell_heading == "name":
												cell_text = cell.replace("\n", ", ") + ":" + "\n"
												yaml_row_heading = "  " + cell_text
												cell_tag = "name"
												cell_text = "    " + cell_tag + ": \"" + cell.replace("\n", ", ") + "\"\n"			
												yaml_row_heading += cell_text																			
											else:

    # "rule02" = {
    #   name                       = "${module.naming.network_security_rule.name_unique}2"
    #   access                     = "Allow"
    #   destination_address_prefix = "*"
    #   destination_port_ranges    = ["80", "443"]
    #   direction                  = "Inbound"
    #   priority                   = 200
    #   protocol                   = "Tcp"
    #   source_address_prefix      = "*"
    #   source_port_range          = "*"
    # }

												if cell_heading == "priority":
													cell_tag = "priority"
												if cell_heading == "port":
													cell_tag = "source_port_range"
												if cell_heading == "protocol":
													cell_tag = "protocol"
												if cell_heading == "source":
													cell_tag = "source_address_prefix"
												if cell_heading == "destination":
													cell_tag = "destination_address_prefix"
												if cell_heading == "destinationport":
													cell_tag = "destination_port_range"
												if cell_heading == "action":
													cell_tag = "access"
												if cell_heading == "direction":
													cell_tag = "direction"
												# cell_text = "	" + cell_heading + ": " + cell.replace("\n", ", ") + "\n"
												cell_text = "    " + cell_tag + ": \"" + cell.replace("\n", ", ") + "\"\n"
												yaml_text += cell_text
										# Write our YAML string to the new text file and close it.
										yaml_file += yaml_row_heading
										yaml_file += yaml_text
								new_yaml = open(outputfilenamepath, 'w')
								# new_yaml = open("./yaml/{nsg_csv}.yaml", 'w')
								all_yaml += yaml_file
								new_yaml.write(yaml_file)
								new_yaml.close()
								csvfile.close()			

		config_nsg_yaml = open("./config_nsg.yaml", 'w')
		config_nsg_yaml.write(all_yaml)
		config_nsg_yaml.close()
# end main funtion csv_to_yaml

def get_filename_without_extension(file_path):
    # Split the file path into root and extension
    root, ext = os.path.splitext(file_path)
    # Return only the root (filename without extension)
    return os.path.basename(root)

class YamlObjectModel:
    def __init__(self, data):
        self._data = data

    def __getitem__(self, path):
        keys = path.split(".")
        value = self._data
        for key in keys:
            if value is None:
                raise KeyError(f"Key '{key}' not found in the YAML data.")
            if key in value:
                value = value[key]
            else:
                raise KeyError(f"Key '{key}' not found in the YAML data.")
        return value


    def get(self, path, default=None):
        try:
            return self[path]  # Reuse __getitem__
        except KeyError:
            return default


# Load the YAML file and assign it to the global object
def load_yaml_file(file_path):
    global yaml_obj
    with open(file_path, 'r') as file:
        yaml_data = yaml.safe_load(file)
        yaml_obj = YamlObjectModel(yaml_data)

def configure_nsg():

		# set variables
		# default_string = "['*']"
		default_string = "['VirtualNetwork']"

		# Clean the string and assign it to a list
		cleaned_list = default_string.strip("[]'").split(",") 

		# project
		project_websubnet_address_prefixes = yaml_obj.get("subnets.project.WebSubnet.address_prefixes", cleaned_list)
		project_appsubnet_address_prefixes = yaml_obj.get("subnets.project.AppSubnet.address_prefixes", cleaned_list)
		project_dbsubnet_address_prefixes = yaml_obj.get("subnets.project.DbSubnet.address_prefixes", cleaned_list)

		project_servicesubnet_address_prefixes = yaml_obj.get("subnets.project.ServiceSubnet.address_prefixes", cleaned_list)
		project_functionappsubnet_address_prefixes = yaml_obj.get("subnets.project.FunctionAppSubnet.address_prefixes", cleaned_list)
		project_apisubnet_address_prefixes = yaml_obj.get("subnets.project.ApiSubnet.address_prefixes", cleaned_list)
		project_systemnodepoolsubnet_address_prefixes = yaml_obj.get("subnets.project.SystemNodePoolSubnet.address_prefixes", cleaned_list)
		project_usernodepoolsubnet_address_prefixes = yaml_obj.get("subnets.project.UserNodePoolSubnet.address_prefixes", cleaned_list)
		project_aisubnet_address_prefixes = yaml_obj.get("subnets.project.AiSubnet.address_prefixes", cleaned_list)
		project_logicappsubnet_address_prefixes = yaml_obj.get("subnets.project.LogicAppSubnet.address_prefixes", cleaned_list)
		project_cisubnet_address_prefixes = yaml_obj.get("subnets.project.CiSubnet.address_prefixes", cleaned_list)
		project_servicebussubnet_address_prefixes = yaml_obj.get("subnets.project.ServiceBusSubnet.address_prefixes", cleaned_list)
		project_cosmosdbsubnet_address_prefixes = yaml_obj.get("subnets.project.CosmosDbSubnet.address_prefixes", cleaned_list)
		project_logicappsubnet_address_prefixes = yaml_obj.get("subnets.project.LogicAppSubnet.address_prefixes", cleaned_list)
		project_appservicesubnet_address_prefixes = yaml_obj.get("subnets.project.AppServiceSubnet.address_prefixes", cleaned_list)

		# management
		management_infrasubnet_address_prefixes = yaml_obj.get("subnets.management.InfraSubnet.address_prefixes", cleaned_list)
		management_securitysubnet_address_prefixes = yaml_obj.get("subnets.management.SecuritySubnet.address_prefixes", cleaned_list)
		management_azurebastionsubnet_address_prefixes = yaml_obj.get("subnets.management.AzureBastionSubnet.address_prefixes", cleaned_list)

		# devops
		devops_runnersubnet_address_prefixes = yaml_obj.get("subnets.devops.RunnerSubnet.address_prefixes", cleaned_list)

		# ingress/egress
		hub_internet_egress_firewallsubnet_address_prefixes = yaml_obj.get("subnets_hub_internet_egress_AzureFirewallSubnet.address_prefixes", cleaned_list)
		hub_internet_ingress_firewallsubnet_address_prefixes = yaml_obj.get("subnets.hub_internet_ingress.AzureFirewallSubnet.address_prefixes", cleaned_list)
		hub_internet_ingress_agwsubnet_address_prefixes = yaml_obj.get("subnets.hub_internet_ingress.AgwSubnet.address_prefixes", cleaned_list)

		hub_intranet_egress_firewallsubnet_address_prefixes = yaml_obj.get("subnets.hub_intranet_egress.AzureFirewallSubnet.address_prefixes", cleaned_list)
		hub_intranet_ingress_firewallsubnet_address_prefixes = yaml_obj.get("subnets.hub_intranet_ingress.AzureFirewallSubnet.address_prefixes", cleaned_list)
		hub_intranet_ingress_agwsubnet_address_prefixes = yaml_obj.get("subnets.hub_intranet_ingress.AgwSubnet.address_prefixes", cleaned_list)



		# project
			
		if project_websubnet_address_prefixes[0]== "":
				project_websubnet_address_prefixes[0] = "VirtualNetwork"

		if project_appsubnet_address_prefixes[0]== "":
			project_appsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_dbsubnet_address_prefixes[0]== "":
			project_dbsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_servicesubnet_address_prefixes[0]== "":
			project_servicesubnet_address_prefixes[0] = "VirtualNetwork"

		if project_functionappsubnet_address_prefixes[0]== "":
			project_functionappsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_apisubnet_address_prefixes[0]== "":
			project_apisubnet_address_prefixes[0] = "VirtualNetwork"

		if project_systemnodepoolsubnet_address_prefixes[0]== "":
			project_systemnodepoolsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_usernodepoolsubnet_address_prefixes[0]== "":
			project_usernodepoolsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_aisubnet_address_prefixes[0]== "":
			project_aisubnet_address_prefixes[0] = "VirtualNetwork"

		if project_logicappsubnet_address_prefixes[0]== "":
			project_logicappsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_cisubnet_address_prefixes[0]== "":
			project_cisubnet_address_prefixes[0] = "VirtualNetwork"

		if project_servicebussubnet_address_prefixes[0]== "":
			project_servicebussubnet_address_prefixes[0] = "VirtualNetwork"

		if project_cosmosdbsubnet_address_prefixes[0]== "":
			project_cosmosdbsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_logicappsubnet_address_prefixes[0]== "":
			project_logicappsubnet_address_prefixes[0] = "VirtualNetwork"

		if project_appservicesubnet_address_prefixes[0]== "":
			project_appservicesubnet_address_prefixes[0] = "VirtualNetwork"

		# management
					
		if management_infrasubnet_address_prefixes[0]== "":
			management_infrasubnet_address_prefixes[0] = "VirtualNetwork"

		if management_securitysubnet_address_prefixes[0]== "":
			management_securitysubnet_address_prefixes[0] = "VirtualNetwork"

		if management_azurebastionsubnet_address_prefixes[0]== "":
			management_azurebastionsubnet_address_prefixes[0] = "VirtualNetwork"


		# devops
							
		if devops_runnersubnet_address_prefixes[0]== "":
			devops_runnersubnet_address_prefixes[0] = "VirtualNetwork"

		# ingress/egress
							
		if hub_internet_egress_firewallsubnet_address_prefixes[0]== "":
			hub_internet_egress_firewallsubnet_address_prefixes[0] = "VirtualNetwork"

		if hub_internet_ingress_firewallsubnet_address_prefixes[0]== "":
			hub_internet_ingress_firewallsubnet_address_prefixes[0] = "VirtualNetwork"

		if hub_internet_ingress_agwsubnet_address_prefixes[0]== "":
			hub_internet_ingress_agwsubnet_address_prefixes[0] = "VirtualNetwork"


		if hub_intranet_egress_firewallsubnet_address_prefixes[0]== "":
			hub_intranet_egress_firewallsubnet_address_prefixes[0] = "VirtualNetwork"

		if hub_intranet_ingress_firewallsubnet_address_prefixes[0]== "":
			hub_intranet_ingress_firewallsubnet_address_prefixes[0] = "VirtualNetwork"

		if hub_intranet_ingress_agwsubnet_address_prefixes[0]== "":
			hub_intranet_ingress_agwsubnet_address_prefixes[0] = "VirtualNetwork"


		# project
		print("project")		
		print(project_websubnet_address_prefixes[0])
		print(project_appsubnet_address_prefixes[0])
		print(project_dbsubnet_address_prefixes[0])
		print(project_servicesubnet_address_prefixes[0])
		print(project_functionappsubnet_address_prefixes[0])
		print(project_apisubnet_address_prefixes[0])
		print(project_systemnodepoolsubnet_address_prefixes[0])
		print(project_usernodepoolsubnet_address_prefixes[0])
		print(project_aisubnet_address_prefixes[0])
		print(project_logicappsubnet_address_prefixes[0])
		print(project_cisubnet_address_prefixes[0])
		print(project_servicebussubnet_address_prefixes[0])
		print(project_cosmosdbsubnet_address_prefixes[0])
		print(project_logicappsubnet_address_prefixes[0])
		print(project_appservicesubnet_address_prefixes[0])

		# management
		print("management")				
		print(management_infrasubnet_address_prefixes[0])
		print(management_securitysubnet_address_prefixes[0])
		print(management_azurebastionsubnet_address_prefixes[0])

		# devops
		print("devops")					
		print(devops_runnersubnet_address_prefixes[0])

		# ingress/egress
		print("ingress/egress")					
		print(hub_internet_egress_firewallsubnet_address_prefixes[0])
		print(hub_internet_ingress_firewallsubnet_address_prefixes[0])
		print(hub_internet_ingress_agwsubnet_address_prefixes[0])

		print(hub_intranet_egress_firewallsubnet_address_prefixes[0])
		print(hub_intranet_ingress_firewallsubnet_address_prefixes[0])
		print(hub_intranet_ingress_agwsubnet_address_prefixes[0])

		# Read the file
		file_path = 'config_nsg.yaml'
		with open(file_path, 'r') as file:
				content = file.read()

		# Perform the substitution
		new_content = content

		# # project vnets subnets
		new_content = re.sub("{{project_websubnet_address_prefixes}}", project_websubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_appsubnet_address_prefixes}}", project_appsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_dbsubnet_address_prefixes}}", project_dbsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_servicesubnet_address_prefixes}}", project_servicesubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_functionappsubnet_address_prefixes}}", project_functionappsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_apisubnet_address_prefixes}}", project_apisubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_systemnodepoolsubnet_address_prefixes}}", project_systemnodepoolsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_usernodepoolsubnet_address_prefixes}}", project_usernodepoolsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_aisubnet_address_prefixes}}", project_aisubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_logicappsubnet_address_prefixes}}", project_logicappsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_cisubnet_address_prefixes}}", project_cisubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_servicebussubnet_address_prefixes}}", project_servicebussubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_cosmosdbsubnet_address_prefixes}}", project_cosmosdbsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_logicappsubnet_address_prefixes}}", project_logicappsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{project_appservicesubnet_address_prefixes}}", project_appservicesubnet_address_prefixes[0].strip(), new_content)


		# # management
		new_content = re.sub("{{management_infrasubnet_address_prefixes}}", management_infrasubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{management_securitysubnet_address_prefixes}}", management_securitysubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{management_azurebastionsubnet_address_prefixes}}", management_azurebastionsubnet_address_prefixes[0].strip(), new_content)

		# # devops
		new_content = re.sub("{{devops_runnersubnet_address_prefixes}}", devops_runnersubnet_address_prefixes[0].strip(), new_content)

		# # ingress/egress
		new_content = re.sub("{{hub_internet_egress_firewallsubnet_address_prefixes}}", hub_internet_egress_firewallsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{hub_internet_ingress_firewallsubnet_address_prefixes}}", hub_internet_ingress_firewallsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{hub_internet_ingress_agwsubnet_address_prefixes}}", hub_internet_ingress_agwsubnet_address_prefixes[0].strip(), new_content)

		new_content = re.sub("{{hub_intranet_egress_firewallsubnet_address_prefixes}}", hub_intranet_egress_firewallsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{hub_intranet_ingress_firewallsubnet_address_prefixes}}", hub_intranet_ingress_firewallsubnet_address_prefixes[0].strip(), new_content)
		new_content = re.sub("{{hub_intranet_ingress_agwsubnet_address_prefixes}}", hub_intranet_ingress_agwsubnet_address_prefixes[0].strip(), new_content)

		# Write the changes back to the file
		with open(file_path, 'w') as file:
				file.write(new_content)

		print(f"Substitution completed in {file_path}.")

# Global object to hold the YAML data
yaml_obj = None

# Convert csv to yaml
csv_to_yaml()

# Load the YAML file and assign it to the global object
load_yaml_file('./../../0-launchpad/scripts/config.yaml')

# Replace variables in config_nsg.yaml
configure_nsg()

# We're done! Close the CSV file.

