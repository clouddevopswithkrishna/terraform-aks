output "id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "Workspace (customer) ID."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}
