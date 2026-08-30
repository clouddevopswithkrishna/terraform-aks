# =============================================================================
# Managed Identity Module - Variables
# =============================================================================
variable "aks_identity_name" {
  description = "Name of the User-Assigned Managed Identity used by the AKS control plane"
  type        = string
}
variable "location" {
  description = "Azure region where the identities will be created"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the Resource Group where the identities will be created"
  type        = string
}
variable "create_kubelet_identity" {
  description = "Whether to create a separate User-Assigned Managed Identity for the kubelet (recommended). If false, AKS will manage its own kubelet identity implicitly."
  type        = bool
  default     = true
}
variable "kubelet_identity_name" {
  description = "Name of the User-Assigned Managed Identity used by the kubelet (nodes). Only used if create_kubelet_identity = true."
  type        = string
  default     = ""
}
variable "network_role_assignment_scope" {
  description = "Resource ID (e.g. VNet ID or Resource Group ID) to grant the AKS control plane identity 'Network Contributor' on. Only used if create_network_role_assignment = true."
  type        = string
  default     = null
}
variable "create_network_role_assignment" {
  description = "Whether to create the Network Contributor role assignment for the AKS identity. Set explicitly rather than inferring from whether network_role_assignment_scope is null, since that value may be unknown until apply (e.g. when it comes from a VNet created in the same run, which breaks a count that depends on its nullness)."
  type        = bool
  default     = false
}
variable "additional_role_assignments" {
  description = <<-EOT
    Map of additional role assignments to create for the identities in this module.
    Key = arbitrary unique name, Value = { scope, role_definition_name, assign_to }.
    assign_to must be either "aks" (control plane identity) or "kubelet" (kubelet identity).
    Example:
    additional_role_assignments = {
      "acr_pull" = {
        scope                 = "/subscriptions/xxx/resourceGroups/rg-acr/providers/Microsoft.ContainerRegistry/registries/myacr"
        role_definition_name  = "AcrPull"
        assign_to              = "kubelet"
      }
    }
  EOT
  type = map(object({
    scope                 = string
    role_definition_name  = string
    assign_to              = string
  }))
  default = {}
}
variable "tags" {
  description = "A map of tags to apply to the identity resources"
  type        = map(string)
  default     = {}
}
