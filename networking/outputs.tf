# =============================================================================
# Networking Module - Outputs
# Consumed primarily by the AKS module (subnet IDs for node pools)
# =============================================================================

output "vnet_id" {
  description = "The resource ID of the created Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the created Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet name => subnet resource ID"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_names" {
  description = "List of all subnet names created"
  value       = [for s in azurerm_subnet.this : s.name]
}

output "nsg_ids" {
  description = "Map of subnet name => NSG resource ID, for subnets that had create_nsg = true"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
