# =============================================================================
# Managed Identity Module - Outputs
# Consumed by the AKS module to attach identities to the cluster
# =============================================================================

output "aks_identity_id" {
  description = "Resource ID of the AKS control plane User-Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.aks.id
}

output "aks_identity_principal_id" {
  description = "Principal (object) ID of the AKS control plane identity"
  value       = azurerm_user_assigned_identity.aks.principal_id
}

output "aks_identity_client_id" {
  description = "Client ID of the AKS control plane identity"
  value       = azurerm_user_assigned_identity.aks.client_id
}

output "kubelet_identity_id" {
  description = "Resource ID of the kubelet User-Assigned Managed Identity (null if not created)"
  value       = var.create_kubelet_identity ? azurerm_user_assigned_identity.kubelet[0].id : null
}

output "kubelet_identity_principal_id" {
  description = "Principal (object) ID of the kubelet identity (null if not created)"
  value       = var.create_kubelet_identity ? azurerm_user_assigned_identity.kubelet[0].principal_id : null
}

output "kubelet_identity_client_id" {
  description = "Client ID of the kubelet identity (null if not created)"
  value       = var.create_kubelet_identity ? azurerm_user_assigned_identity.kubelet[0].client_id : null
}
