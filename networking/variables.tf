variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create networking resources."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network, e.g. [\"10.10.0.0/16\"]."
  type        = list(string)
}

variable "dns_servers" {
  description = "Custom DNS servers for the VNet. Leave empty to use Azure-provided DNS."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = <<-EOT
    Map of subnets to create. Key is a logical name (e.g. "aks", "appgw") used to
    reference the subnet id elsewhere (module.networking.subnet_ids["aks"]).
  EOT
  type = map(object({
    name                               = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(string, "Disabled")
    delegation = optional(object({
      name                    = string
      service_delegation_name = string
      actions                 = list(string)
    }))
  }))
}

variable "tags" {
  description = "Tags to apply to networking resources."
  type        = map(string)
  default     = {}
}
