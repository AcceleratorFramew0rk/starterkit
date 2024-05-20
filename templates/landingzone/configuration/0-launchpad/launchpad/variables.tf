variable "configuration_file_path" {
  description = "(Optional) A configuration file path."
  type        = string
  default     = ""
}

variable "random_length" {
  description = "(Optional) A random length for the naming."
  type        = number
  default     = 3
}

variable "global_tags" {
  description = "(Optional) A random length for the naming."
  default     = {
    env   = "Dev"
    owner = "AVM Terraform GCC Starter Kit"
    dept  = "IT"
  }
}

variable "location" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  type        = string
  default     = "southeastasia"
  nullable    = true
}
