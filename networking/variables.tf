# =============================================================================
# Networking Module - Variables
# =============================================================================

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space (CIDR blocks) for the Virtual Network"
  type        = list(string)
}

variable "location" {
  description = "Azure region where networking resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where networking resources will be created"
  type        = string
}

variable "dns_servers" {
  description = "Optional list of custom DNS servers for the VNet. Leave empty to use Azure-provided DNS."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = <<-EOT
    Map of subnets to create. Key = subnet name, Value = subnet configuration.

    Example:
    subnets = {
      "snet-aks-system" = {
        address_prefixes = ["10.10.1.0/24"]
        create_nsg       = true
      }
      "snet-aks-user" = {
        address_prefixes  = ["10.10.2.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        create_nsg        = true
      }
    }
  EOT
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    create_nsg         = optional(bool, false)
    delegation = optional(object({
      name                     = string
      service_delegation_name = string
      actions                  = optional(list(string), [])
    }), null)
  }))
}

variable "tags" {
  description = "A map of tags to apply to networking resources"
  type        = map(string)
  default     = {}
}
