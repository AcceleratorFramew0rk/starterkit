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

variable "ingress_subnet_id" {
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

variable "private_dns_zones_enabled" {
  type        = bool  
  default = true
}

variable "subnet_name" {
  type        = string  
  default = "AppServiceSubnet"
}

variable "ingress_subnet_name" {
  type        = string  
  default = "WebSubnet"
}

variable "linux_fx_version" {
  type        = string  
  # default = "NODE:20-lts"
  # default = "DOCKER|mcr.microsoft.com/azure-functions/python:4" # Public Docker image
  default = "DOCKER|nginx:latest" # Public Docker image
}


variable "dotnet_framework_version" {
  type        = string  
  default = null # "v6.0" 
}


# variable "appservice_api_enabled" {
#   type        = bool  
#   default = false
# }

# variable "appservice_web_enabled" {
#   type        = bool  
#   default = true
# }

variable "resource_names" {
  description = "List of App Service names"
  type        = list(string)
  default     = ["web", "api"]
}

variable "kind" {
  type        = string  
  default = "Linux" # "Windows"
}

