# =============================================================================
# AKS Node Pool Module
# Creates one or more additional (user) node pools attached to an existing
# AKS cluster. Kept separate from the AKS module so pools can be added,
# removed, resized, or upgraded independently without touching/replacing
# the cluster resource itself.
#
# Driven entirely by a map (var.node_pools), so scaling from 1 pool to N
# pools - or changing an individual pool's VM size, node count, autoscaling,
# or Kubernetes version - is purely a terraform.tfvars change.
# =============================================================================
resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = var.node_pools
  name                  = each.key
  kubernetes_cluster_id = var.cluster_id
  vm_size        = each.value.vm_size
  vnet_subnet_id = coalesce(each.value.subnet_id, var.default_subnet_id)
  # Defaults to the cluster's Kubernetes version if not explicitly overridden,
  # so pools stay in sync unless you deliberately pin one behind/ahead.
  orchestrator_version = coalesce(each.value.kubernetes_version, var.default_kubernetes_version)
  mode = each.value.mode
  os_type         = each.value.os_type
  os_disk_size_gb = each.value.os_disk_size_gb
  os_disk_type    = each.value.os_disk_type
  zones = each.value.zones
  enable_auto_scaling = each.value.enable_auto_scaling
  node_count          = each.value.enable_auto_scaling ? null : each.value.node_count
  min_count           = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count            = each.value.enable_auto_scaling ? each.value.max_count : null
  max_pods = each.value.max_pods
  # Taints/labels allow dedicating pools to specific workloads
  # (e.g. GPU, spot, or a specific application tier).
  node_labels = each.value.node_labels
  node_taints = each.value.node_taints
  priority        = each.value.priority
  eviction_policy = each.value.priority == "Spot" ? each.value.eviction_policy : null
  spot_max_price  = each.value.priority == "Spot" ? each.value.spot_max_price : null
  upgrade_settings {
    max_surge = each.value.upgrade_max_surge
  }
  tags = merge(var.tags, each.value.tags)
  lifecycle {
    ignore_changes = [
      # Avoid Terraform fighting the cluster autoscaler on every plan.
      node_count,
    ]
  }
}
