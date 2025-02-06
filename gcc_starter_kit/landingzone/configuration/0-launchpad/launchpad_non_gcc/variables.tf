variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "name_prefix" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  type        = string
  default     = "ignite"
  nullable    = true
}

variable "location" {
  description = "(Optional) A prefix for the location of all the resource groups and resources."
  type        = string
  default     = "southeastasia"
  nullable    = true
}

# log analytics workspace
variable "solution_plan_map" {
  description = "Specifies solutions to deploy to log analytics workspace"
  default     = {
    ContainerInsights= {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
  }
  type = map(any)
}

# others
variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    createdWith = "Terraform"
    env = "sandpit"
  }
}
variable "global_tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    createdWith = "Terraform"
    env = "sandpit"
  }
}

variable "is_prefix" {
  description = "(Optional) A prefix flag. true if prefix is used. false if suffix is used."
  type        = bool
  default     = true
}

# ----------------------------------------------------
# config virtual networks
# ----------------------------------------------------
variable "resource_group_name" {
  type        = string  
  description = "(Optional) Specifies resource group name of gcci_platform"
  default     = "gcci_platform"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string  
  description = "(Optional) Specifies log_analytics_workspace_resource_group_name of gcci_platform"
  default     = "gcci-agency-law"
}

variable "log_analytics_workspace_name" {
  type        = string  
  description = "(Optional) Specifies log_analytics_workspace_name of gcci_platform"
  default     = "gcci-agency-workspace"
}

variable "vnets_hub_ingress_internet_name" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_ingress_internet_name of gcci_platform"
  default     = null
}

variable "vnets_hub_ingress_internet_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_ingress_internet_cidr of gcci_platform"
  default     = null
}

variable "vnets_hub_egress_internet_name" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_egress_internet_name of gcci_platform"
  default     = null
}

variable "vnets_hub_egress_internet_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_egress_internet_cidr of gcci_platform"
  default     = null
}

variable "vnets_hub_ingress_intranet_name" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_ingress_intranet_name of gcci_platform"
  default     = null
}

variable "vnets_hub_ingress_intranet_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_ingress_intranet_cidr of gcci_platform"
  default     = null
}

variable "vnets_hub_egress_intranet_name" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_egress_intranet_name of gcci_platform"
  default     = null
}

variable "vnets_hub_egress_intranet_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_hub_egress_intranet_cidr of gcci_platform"
  default     = null
}

variable "vnets_management_name" {
  type        = string  
  description = "(Optional) Specifies vnets_management_name of gcci_platform"
  default     = null
}

variable "vnets_management_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_management_cidr of gcci_platform"
  default     = null
}

variable "vnets_project_name" {
  type        = string  
  description = "(Optional) Specifies vnets_project_name of gcci_platform"
  default     = null
}

variable "vnets_project_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_project_cidr of gcci_platform"
  default     = null
}

variable "vnets_devops_name" {
  type        = string  
  description = "(Optional) Specifies vnets_devops_name of gcci_platform"
  default     = null
}

variable "vnets_devops_cidr" {
  type        = string  
  description = "(Optional) Specifies vnets_project_cidr of gcci_platform"
  default     = null
}