output "id" {
  description = "Resource ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "principal_id" {
  description = "Principal (object) ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client (application) ID of the managed identity."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "name" {
  description = "Name of the managed identity."
  value       = azurerm_user_assigned_identity.this.name
}
