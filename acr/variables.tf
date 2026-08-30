variable "name" {
  description = "Name of the Azure Container Registry (globally unique, alphanumeric only)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the ACR will be created"
  type        = string
}

variable "location" {
  description = "Azure region where the ACR will be created"
  type        = string
}

variable "sku" {
  description = "ACR SKU: Basic, Standard, or Premium"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable the ACR admin account (username/password)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the ACR"
  type        = map(string)
  default     = {}
}
