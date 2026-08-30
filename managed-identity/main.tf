# =============================================================================
# Managed Identity Module
# Creates User-Assigned Managed Identities used by AKS:
#   - Control plane identity (used by AKS to manage the cluster's Azure
#     resources such as load balancers, route tables, and networking)
#   - Kubelet identity (optional, recommended - used by the nodes to pull
#     images from ACR, etc., kept separate from the control plane identity
#     per Azure best practice)
# Also creates the role assignments needed for AKS to operate correctly
# (e.g. Network Contributor on the VNet for CNI, Managed Identity Operator
# on the kubelet identity for the control plane identity).
# =============================================================================
resource "azurerm_user_assigned_identity" "aks" {
  name                = var.aks_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}
resource "azurerm_user_assigned_identity" "kubelet" {
  count = var.create_kubelet_identity ? 1 : 0
  name                = var.kubelet_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}
# -----------------------------------------------------------------------------
# Allow the AKS control plane identity to manage networking resources
# (required so AKS can create/manage NICs, route tables, LBs in the VNet)
# -----------------------------------------------------------------------------
resource "azurerm_role_assignment" "aks_network_contributor" {
  count = var.create_network_role_assignment ? 1 : 0
  scope                = var.network_role_assignment_scope
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
# -----------------------------------------------------------------------------
# Allow the AKS control plane identity to operate the separate kubelet
# identity (required by Azure when bringing your own kubelet identity)
# -----------------------------------------------------------------------------
resource "azurerm_role_assignment" "aks_managed_identity_operator" {
  count = var.create_kubelet_identity ? 1 : 0
  scope                = azurerm_user_assigned_identity.kubelet[0].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
# -----------------------------------------------------------------------------
# Any additional role assignments the caller wants to attach to the AKS
# control plane identity (e.g. ACR Pull on a specific registry, Key Vault
# Secrets User, etc.) - kept generic so this module doesn't need to change
# as new requirements come up.
# -----------------------------------------------------------------------------
resource "azurerm_role_assignment" "additional" {
  for_each = var.additional_role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.assign_to == "kubelet" && var.create_kubelet_identity ? azurerm_user_assigned_identity.kubelet[0].principal_id : azurerm_user_assigned_identity.aks.principal_id
}
