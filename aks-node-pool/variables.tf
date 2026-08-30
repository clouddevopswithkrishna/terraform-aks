# =============================================================================
# AKS Node Pool Module - Variables
# =============================================================================

variable "cluster_id" {
  description = "Resource ID of the AKS cluster (from the aks module) to attach these node pools to"
  type        = string
}

variable "default_subnet_id" {
  description = "Default subnet ID to use for node pools that don't specify their own subnet_id"
  type        = string
}

variable "default_kubernetes_version" {
  description = "Default Kubernetes version applied to node pools that don't override kubernetes_version. Normally set to the same value as the cluster's kubernetes_version."
  type        = string
}

variable "node_pools" {
  description = <<-EOT
    Map of user node pools to create. Key = pool name, Value = pool configuration.
    Adding, removing, resizing, or upgrading a pool is done purely by editing
    this map in terraform.tfvars - no module or code changes required.

    Example:
    node_pools = {
      "userpool1" = {
        vm_size              = "Standard_D4s_v5"
        mode                 = "User"
        os_type              = "Linux"
        enable_auto_scaling  = true
        node_count           = 3
        min_count            = 2
        max_count            = 10
        max_pods             = 30
        zones                = ["1", "2", "3"]
        priority             = "Regular"
        node_labels          = { workload = "general" }
        node_taints          = []
      }
      "spotpool1" = {
        vm_size              = "Standard_D4s_v5"
        mode                 = "User"
        os_type              = "Linux"
        enable_auto_scaling  = true
        node_count           = 0
        min_count            = 0
        max_count            = 5
        max_pods             = 30
        priority             = "Spot"
        eviction_policy      = "Delete"
        spot_max_price       = -1
        node_labels          = { workload = "batch" }
        node_taints          = ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
      }
    }
  EOT
  type = map(object({
    vm_size              = string
    subnet_id             = optional(string, null)
    kubernetes_version   = optional(string, null)
    mode                  = optional(string, "User")
    os_type               = optional(string, "Linux")
    os_disk_size_gb       = optional(number, 128)
    os_disk_type          = optional(string, "Managed")
    zones                 = optional(list(string), [])
    enable_auto_scaling  = optional(bool, true)
    node_count            = optional(number, 1)
    min_count             = optional(number, 1)
    max_count              = optional(number, 3)
    max_pods               = optional(number, 30)
    node_labels           = optional(map(string), {})
    node_taints           = optional(list(string), [])
    priority              = optional(string, "Regular")
    eviction_policy       = optional(string, null)
    spot_max_price         = optional(number, null)
    upgrade_max_surge     = optional(string, "33%")
    tags                  = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to apply to all node pools (merged with any per-pool tags)"
  type        = map(string)
  default     = {}
}
