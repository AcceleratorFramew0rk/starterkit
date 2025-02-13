# insert your variables here
variable "location" {
  type        = string  
  default = "southeastasia"
}

variable "vnet_id" {
  type        = string  
  default = null
}

variable "vnet_name" {
  type        = string  
  default = "gcci-vnet-devops"
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

variable "image" {
  type        = string  
  default = "acceleratorframew0rk/gccstarterkit-avm-sde:0.3" # "gccstarterkit/gccstarterkit-avm-sde:0.2"
}

variable "cpu" {
  type        = string  
  default = "1"
}

variable "memory" {
  type        = string  
  default = "2"
}

variable "subnet_name" {
  type        = string  
  default = "RunnerSubnet"
}
