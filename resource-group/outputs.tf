# =============================================================================
# Resource Group Module - Outputs
# These outputs are consumed by the networking, identity, and AKS modules
# =============================================================================

output "name" {
  description = "The name of the created Resource Group"
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "The resource ID of the created Resource Group"
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "The Azure region of the created Resource Group"
  value       = azurerm_resource_group.this.location
}
