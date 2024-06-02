# Takes a file CSV file called "data.csv" and outputs each row as a numbered YAML file.
# Data in the first row of the CSV is assumed to be the column heading.

# Import the python library for parsing CSV files.
import csv
import sys
import os

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

# if len(sys.argv) < 2:
# 		print("Usage: python example.py <your_input>")
# 		sys.exit(1)
# # The second argument is what we are interested in
# nsg_csv = sys.argv[1]
# print(f"You entered: {nsg_csv}")

csv_to_yaml()

# We're done! Close the CSV file.

