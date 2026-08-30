variable "name" {
  description = "Name of the Azure Container Registry (must be globally unique, alphanumeric)."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the registry."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku" {
  description = "ACR SKU: Basic, Standard, or Premium."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable the ACR admin account (not recommended for production; prefer AcrPull role assignment)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the registry."
  type        = map(string)
  default     = {}
}
