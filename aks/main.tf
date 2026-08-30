############################################
# AKS Module: Cluster + Default Node Pool
############################################

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier
  node_resource_group = var.node_resource_group_name

  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name                         = var.default_node_pool.name
    vm_size                      = var.default_node_pool.vm_size
    orchestrator_version         = coalesce(var.default_node_pool.orchestrator_version, var.kubernetes_version)
    vnet_subnet_id               = var.subnet_id
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    max_pods                     = var.default_node_pool.max_pods
    zones                        = var.default_node_pool.availability_zones
    auto_scaling_enabled         = var.default_node_pool.enable_auto_scaling
    node_count                   = var.default_node_pool.enable_auto_scaling ? null : var.default_node_pool.node_count
    min_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.min_count : null
    max_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.max_count : null
    only_critical_addons_enabled = var.only_critical_addons_on_default_pool
    tags                         = var.tags
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_policy      = var.network_profile.network_policy
    service_cidr        = var.network_profile.service_cidr
    dns_service_ip      = var.network_profile.dns_service_ip
    load_balancer_sku   = var.network_profile.load_balancer_sku
    outbound_type       = var.network_profile.outbound_type
    pod_cidr            = var.network_profile.network_plugin == "kubenet" ? var.network_profile.pod_cidr : null
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_azure_rbac ? [1] : []
    content {
      azure_rbac_enabled    = true
      admin_group_object_ids = var.admin_group_object_ids
    }
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id == null ? [] : [1]
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window == null ? [] : [var.maintenance_window]
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
    }
  }

  workload_identity_enabled = var.enable_workload_identity
  oidc_issuer_enabled       = var.enable_oidc_issuer

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
}
