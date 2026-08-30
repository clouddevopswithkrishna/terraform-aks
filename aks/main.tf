resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version      = var.kubernetes_version
  sku_tier                = var.sku_tier
  automatic_channel_upgrade = var.automatic_upgrade_channel != "" ? var.automatic_upgrade_channel : null   # was: automatic_upgrade_channel
  node_os_channel_upgrade   = var.node_os_upgrade_channel                                                  # was: node_os_upgrade_channel

  private_cluster_enabled = var.private_cluster_enabled

  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  default_node_pool {
    name                          = var.system_node_pool.name
    vm_size                       = var.system_node_pool.vm_size
    vnet_subnet_id                = var.subnet_id
    zones                         = var.system_node_pool.zones
    os_disk_size_gb               = var.system_node_pool.os_disk_size_gb
    only_critical_addons_enabled  = var.system_node_pool.only_critical_addons_enabled

    auto_scaling_enabled = var.system_node_pool.enable_auto_scaling   # was: enable_auto_scaling
    node_count           = var.system_node_pool.enable_auto_scaling ? null : var.system_node_pool.node_count
    min_count            = var.system_node_pool.enable_auto_scaling ? var.system_node_pool.min_count : null
    max_count             = var.system_node_pool.enable_auto_scaling ? var.system_node_pool.max_count : null

    max_pods = var.system_node_pool.max_pods

    upgrade_settings {
      max_surge = var.system_node_pool.upgrade_max_surge
    }

    tags = var.tags
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.aks_identity_id]
  }

  dynamic "kubelet_identity" {
    for_each = var.kubelet_identity_id != null ? [1] : []
    content {
      client_id                 = var.kubelet_identity_client_id
      object_id                 = var.kubelet_identity_object_id
      user_assigned_identity_id = var.kubelet_identity_id
    }
  }

  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_plugin_mode = var.network_profile.network_plugin_mode
    network_policy      = var.network_profile.network_policy
    service_cidr        = var.network_profile.service_cidr
    dns_service_ip       = var.network_profile.dns_service_ip
    pod_cidr             = var.network_profile.pod_cidr
    load_balancer_sku   = var.network_profile.load_balancer_sku
    outbound_type         = var.network_profile.outbound_type
  }

  dynamic "api_server_access_profile" {
    for_each = length(var.authorized_ip_ranges) > 0 ? [1] : []
    content {
      authorized_ip_ranges = var.authorized_ip_ranges
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.aad_rbac.enabled ? [1] : []
    content {
      tenant_id              = var.aad_rbac.tenant_id
      admin_group_object_ids = var.aad_rbac.admin_group_object_ids
      azure_rbac_enabled     = var.aad_rbac.azure_rbac_enabled
    }
  }

  azure_policy_enabled = var.azure_policy_enabled

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [1] : []
    content {
      dynamic "allowed" {
        for_each = var.maintenance_window.allowed
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
}
