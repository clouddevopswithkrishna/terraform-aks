variable "name" {
  description = "Name of the user-assigned managed identity."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the identity."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "role_assignments" {
  description = "Map of role assignments to grant to this identity."
  type = map(object({
    scope                = string
    role_definition_name = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the identity."
  type        = map(string)
  default     = {}
}
