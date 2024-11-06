# insert your variables here
variable "location" {
  type        = string  
  default = "southeastasia"
}

variable "vnet_id" {
  type        = string  
  default = null
}

variable "subnet_id" {
  type        = string  
  default = null
}

variable "log_analytics_workspace_id" {
  type        = string  
  default = null
}

variable "prefix" {
  type        = string  
  default = "aaf"
}

variable "environment" {
  type        = string  
  default = "sandpit"
}


# -------------------------
# variable "azure_region" {
#   description = "Azure region to use."
#   type        = string
# }

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
  default = "internet-cdn"
}

# variable "environment" {
#   description = "Project environment"
#   type        = string
# }

variable "stack" {
  description = "Project stack name"
  type        = string
  default = "stack"
}
