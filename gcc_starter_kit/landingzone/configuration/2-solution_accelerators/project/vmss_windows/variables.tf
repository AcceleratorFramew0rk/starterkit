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

variable "source_image_resource_id" {
  type        = string  
  # example of image resource id
  # "/subscriptions/xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/aoaiuat-rg-solution-accelerators-project-virtualmachine/providers/Microsoft.Compute/galleries/gccvmgallery/images/vmdefinition001/versions/0.0.1"
  # /subscriptions/xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx/resourceGroups/aoaiuat-rg-solution-accelerators-project-virtualmachine/providers/Microsoft.Compute/galleries/gccvmgallery/images/vmdefinition001
  default = null # "/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Compute/images/<custom_image_name>"

}


variable "virtualmachine_os_type" {
  type        = string  
  default = "Windows" # "Windows" or "Linux" 
}

variable "vnet_type" {
  type        = string  
  default = "project" # "" or "project" or "devops" 
}

# allow cusomization of the private endpoint subnet name
variable "subnet_name" {
  type        = string  
  default = "AppSubnet"
}