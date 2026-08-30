output "id" {
  description = "Resource ID of the node pool."
  value       = azurerm_kubernetes_cluster_node_pool.this.id
}

output "name" {
  description = "Name of the node pool."
  value       = azurerm_kubernetes_cluster_node_pool.this.name
}
