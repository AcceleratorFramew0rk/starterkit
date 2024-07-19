locals {
  const_yaml = "yaml"
  const_yml  = "yml"
  configuration_file_path = ""
  location = "southeastasia"

  config_file_name      = local.configuration_file_path == "" ? "config_nsg.yaml" : basename(local.configuration_file_path)
  config_file_split     = split(".", local.config_file_name)
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
}
locals {
  config_template_file_variables = {
    default_location                = local.location # var.default_location
  }

  config = (local.config_file_extension == local.const_yaml ?
    yamldecode(templatefile("./../../scripts/${local.config_file_name}", local.config_template_file_variables)) :
    jsondecode(templatefile("./../../scripts//${local.config_file_name}", local.config_template_file_variables))
  )
}

