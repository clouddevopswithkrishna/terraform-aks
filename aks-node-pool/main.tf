############################################
# AKS Node Pool Module (additional/user node pools)
############################################

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  name                  = var.name
  kubernetes_cluster_id = var.aks_cluster_id
  vm_size               = var.vm_size
  vnet_subnet_id        = var.subnet_id
  orchestrator_version  = var.orchestrator_version
  os_type               = var.os_type
  os_disk_size_gb       = var.os_disk_size_gb
  mode                  = var.mode
  max_pods              = var.max_pods
  zones                 = var.availability_zones

  auto_scaling_enabled = var.enable_auto_scaling
  node_count            = var.enable_auto_scaling ? null : var.node_count
  min_count             = var.enable_auto_scaling ? var.min_count : null
  max_count             = var.enable_auto_scaling ? var.max_count : null

  node_labels = var.node_labels
  node_taints = var.node_taints

  tags = var.tags

  lifecycle {
    ignore_changes = [node_count]
  }
}
