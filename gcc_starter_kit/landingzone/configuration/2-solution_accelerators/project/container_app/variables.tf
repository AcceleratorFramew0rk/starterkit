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

variable "image" {
  type        = string  
  default = "nginx:latest"
}

variable "cpu" {
  type        = string  
  default = "0.5"
}

variable "memory" {
  type        = string  
  default = "1Gi" # "2"
}

variable "frontend_image" {
  type        = string  
  default = "docker.io/hashicorp/counting-service:0.0.2"
}

variable "backend_image" {
  type        = string  
  default = "docker.io/hashicorp/dashboard-service:0.0.4"
}

variable "private_dns_zones_enabled" {
  type        = bool  
  default = true
}

variable "ingress_subnet_id" {
  type        = string  
  default = null
}

variable "subnet_name" {
  type        = string  
  default = "ContainerAppSubnet"
}

variable "ingress_subnet_name" {
  type        = string  
  default = "WebSubnet"
}

variable "resource_names" {
  description = "List of Virtual Machine names"
  type        = list(string)
  default     = ["web", "api"] # default to two container app - ensure the value is unique  
}

variable "workload_profile_type" {
  type        = string  
  # ** IMPORTANT ** workload_profile_type = "D16" failed, change to other value
  default = "D16" # Possible values include Consumption, D4, D8, D16, D32, E4, E8, E16 and E32
}