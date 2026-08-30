# =============================================================================
# Networking Module
# Creates the Virtual Network and one or more Subnets used by AKS
# (system node pool, user node pools, and any future subnets e.g. for
# App Gateway ingress, private endpoints, etc.)
# =============================================================================

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  # Optional service endpoints per subnet, e.g. ["Microsoft.Storage", "Microsoft.KeyVault"]
  service_endpoints = try(each.value.service_endpoints, [])

  # Optional subnet delegation (e.g. for App Gateway, ACI, etc.)
  dynamic "delegation" {
    for_each = try(each.value.delegation, null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = try(delegation.value.actions, [])
      }
    }
  }
}

# Optional Network Security Group(s) - one per subnet if defined in var.subnets
resource "azurerm_network_security_group" "this" {
  for_each = { for k, v in var.subnets : k => v if try(v.create_nsg, false) }

  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = azurerm_network_security_group.this

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.id
}
