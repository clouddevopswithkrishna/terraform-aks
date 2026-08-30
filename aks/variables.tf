# =============================================================================
# AKS Module - Variables
# =============================================================================

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster (must be unique within the region)"
  type        = string
}

variable "location" {
  description = "Azure region where the AKS cluster will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the AKS cluster will be created"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the control plane and default node pool (e.g. \"1.32\")"
  type        = string
}

variable "sku_tier" {
  description = "AKS pricing tier for the control plane. One of: Free, Standard, Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be one of: Free, Standard, Premium."
  }
}

variable "automatic_upgrade_channel" {
  description = "Automatic upgrade channel for the Kubernetes control plane. One of: patch, rapid, node-image, stable, or \"\" to disable."
  type        = string
  default     = ""
}

variable "node_os_upgrade_channel" {
  description = "Automatic upgrade channel for node OS images. One of: Unmanaged, SecurityPatch, NodeImage, None."
  type        = string
  default     = "NodeImage"
}

variable "private_cluster_enabled" {
  description = "Whether the AKS API server should be private (not publicly accessible)"
  type        = bool
  default     = false
}

variable "oidc_issuer_enabled" {
  description = "Enable the OIDC issuer URL, required for Azure AD Workload Identity"
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Enable Azure AD Workload Identity for pods"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet ID (from the networking module) into which the system node pool will be deployed"
  type        = string
}

variable "system_node_pool" {
  description = <<-EOT
    Configuration for the default (system) node pool.

    Example:
    system_node_pool = {
      name                          = "system"
      vm_size                       = "Standard_D2s_v5"
      zones                         = ["1", "2", "3"]
      os_disk_size_gb               = 128
      only_critical_addons_enabled = true
      enable_auto_scaling           = true
      node_count                    = 3
      min_count                     = 3
      max_count                     = 5
      max_pods                      = 30
      upgrade_max_surge             = "33%"
    }
  EOT
  type = object({
    name                          = string
    vm_size                       = string
    zones                         = optional(list(string), [])
    os_disk_size_gb               = optional(number, 128)
    only_critical_addons_enabled = optional(bool, true)
    enable_auto_scaling           = optional(bool, true)
    node_count                    = optional(number, 3)
    min_count                     = optional(number, 3)
    max_count                      = optional(number, 5)
    max_pods                       = optional(number, 30)
    upgrade_max_surge             = optional(string, "33%")
  })
}

variable "aks_identity_id" {
  description = "Resource ID of the User-Assigned Managed Identity for the AKS control plane (from the identity module)"
  type        = string
}

variable "kubelet_identity_id" {
  description = "Resource ID of the User-Assigned Managed Identity for the kubelet (from the identity module). Set to null to let AKS manage its own."
  type        = string
  default     = null
}

variable "kubelet_identity_client_id" {
  description = "Client ID of the kubelet identity. Required if kubelet_identity_id is set."
  type        = string
  default     = null
}

variable "kubelet_identity_object_id" {
  description = "Object (principal) ID of the kubelet identity. Required if kubelet_identity_id is set."
  type        = string
  default     = null
}

variable "network_profile" {
  description = <<-EOT
    Networking configuration for the AKS cluster.

    Example:
    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
      network_policy      = "azure"
      service_cidr        = "10.100.0.0/16"
      dns_service_ip       = "10.100.0.10"
      pod_cidr             = "10.200.0.0/16"
      load_balancer_sku   = "standard"
      outbound_type        = "loadBalancer"
    }
  EOT
  type = object({
    network_plugin      = string
    network_plugin_mode = optional(string, null)
    network_policy      = optional(string, "azure")
    service_cidr        = string
    dns_service_ip       = string
    pod_cidr             = optional(string, null)
    load_balancer_sku   = optional(string, "standard")
    outbound_type        = optional(string, "loadBalancer")
  })
}

variable "authorized_ip_ranges" {
  description = "List of CIDR ranges allowed to access the AKS API server. Empty list = no restriction (all allowed, subject to private_cluster_enabled)."
  type        = list(string)
  default     = []
}

variable "aad_rbac" {
  description = <<-EOT
    Azure AD RBAC integration settings.

    Example:
    aad_rbac = {
      enabled                 = true
      tenant_id               = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      admin_group_object_ids = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
      azure_rbac_enabled     = true
    }
  EOT
  type = object({
    enabled                 = bool
    tenant_id               = optional(string, null)
    admin_group_object_ids = optional(list(string), [])
    azure_rbac_enabled     = optional(bool, true)
  })
  default = {
    enabled = false
  }
}

variable "azure_policy_enabled" {
  description = "Enable the Azure Policy add-on for AKS"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of a Log Analytics Workspace to enable Container Insights (oms_agent). Set to null to disable."
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = <<-EOT
    Optional maintenance window configuration for cluster/node OS auto-upgrades.

    Example:
    maintenance_window = {
      allowed = [
        { day = "Sunday", hours = [1, 2, 3] }
      ]
    }
  EOT
  type = object({
    allowed = list(object({
      day   = string
      hours = list(number)
    }))
  })
  default = null
}

variable "tags" {
  description = "A map of tags to apply to the AKS cluster and its default node pool"
  type        = map(string)
  default     = {}
}
