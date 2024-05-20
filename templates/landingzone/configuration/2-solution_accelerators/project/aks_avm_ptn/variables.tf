variable "client_id" {
  default="azureaksuser"
}

variable "client_secret" {
  default="!qaz@wsx@1234567890"
}

variable "key_vault_firewall_bypass_ip_cidr" {
  type    = string
  default = null
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}

variable "kubernetes_version" {
  description = "Specifies the AKS Kubernetes version"
  default     = "1.29.0" # "1.26.3"
  type        = string
}

variable "tags" {
  default = {
    purpose = "aks cluster" 
    project_code = "aoaidev" # local.global_settings.prefix 
    env = "sandpit" # local.global_settings.environment 
    zone = "project"
    tier = "app"  
  }
}
