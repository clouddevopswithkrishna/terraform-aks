# =============================================================================
# Resource Group Module - Variables
# =============================================================================

variable "resource_group_name" {
  description = "Name of the Azure Resource Group to create"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "resource_group_name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "Azure region where the Resource Group will be created (e.g. eastus, westeurope)"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to the Resource Group"
  type        = map(string)
  default     = {}
}
