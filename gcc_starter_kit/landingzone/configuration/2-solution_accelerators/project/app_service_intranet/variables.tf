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

variable "private_dns_zones_enabled" {
  type        = bool  
  default = true
}

variable "intranet_enabled" {
  type        = bool  
  default = false
}

variable "ingress_subnet_id" {
  type        = string  
  default = null
}

variable "subnet_name" {
  type        = string  
  default = "AppServiceIntranetSubnet"
}

variable "ingress_subnet_name" {
  type        = string  
  default = "WebIntranetSubnet"
}