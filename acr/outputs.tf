output "id" {
  description = "Resource ID of the ACR"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "Name of the ACR"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "Login server hostname of the ACR (e.g. myacr.azurecr.io)"
  value       = azurerm_container_registry.this.login_server
}
