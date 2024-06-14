variable "subnet_ids" {
  description = "(Required) A map of subnet ids to associate with the NAT Gateway"
  type = map(string)
}

variable "nat_gateway_id" {
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}