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
  # "/subscriptions/e22a351f-db36-4a02-9793-0f2189d5f3ab/resourceGroups/aoaiuat-rg-solution-accelerators-project-virtualmachine/providers/Microsoft.Compute/galleries/gccvmgallery/images/vmdefinition001/versions/0.0.1"
  # /subscriptions/e22a351f-db36-4a02-9793-0f2189d5f3ab/resourceGroups/aoaiuat-rg-solution-accelerators-project-virtualmachine/providers/Microsoft.Compute/galleries/gccvmgallery/images/vmdefinition001
  default = null # "/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Compute/images/<custom_image_name>"

}

