# =============================================================================
# AKS Node Pool Module - Outputs
# =============================================================================

output "node_pool_ids" {
  description = "Map of node pool name => resource ID"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.this : k => v.id }
}

output "node_pool_names" {
  description = "List of all user node pool names created"
  value       = [for v in azurerm_kubernetes_cluster_node_pool.this : v.name]
}
