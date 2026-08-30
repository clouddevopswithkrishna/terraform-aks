variable "cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the cluster."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes control-plane version, e.g. \"1.30\"."
  type        = string
}

variable "sku_tier" {
  description = "AKS SKU tier: Free, Standard, or Premium."
  type        = string
  default     = "Standard"
}

variable "private_cluster_enabled" {
  description = "Whether the AKS API server is private."
  type        = bool
  default     = false
}

variable "node_resource_group_name" {
  description = "Name of the auto-generated node resource group (MC_*). Null lets Azure name it."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID for the default node pool."
  type        = string
}

variable "identity_id" {
  description = "Resource ID of the user-assigned managed identity used by the cluster control plane."
  type        = string
}

variable "only_critical_addons_on_default_pool" {
  description = "Taint the default node pool so only critical system pods are scheduled on it. Recommended for production so application workloads run on dedicated node pools."
  type        = bool
  default     = false
}

variable "default_node_pool" {
  description = "Configuration for the AKS default (system) node pool."
  type = object({
    name                 = string
    vm_size              = string
    node_count           = number
    min_count            = number
    max_count            = number
    enable_auto_scaling  = bool
    os_disk_size_gb      = number
    orchestrator_version = optional(string)
    availability_zones   = optional(list(string), [])
    max_pods             = optional(number, 30)
  })
}

variable "network_profile" {
  description = "AKS networking configuration."
  type = object({
    network_plugin    = string
    network_policy    = optional(string)
    service_cidr      = optional(string)
    dns_service_ip    = optional(string)
    pod_cidr          = optional(string)
    load_balancer_sku = optional(string, "standard")
    outbound_type     = optional(string, "loadBalancer")
  })
}

variable "enable_azure_rbac" {
  description = "Enable Azure AD + Azure RBAC integration for Kubernetes authorization."
  type        = bool
  default     = false
}

variable "admin_group_object_ids" {
  description = "Azure AD group object IDs granted cluster-admin via Azure RBAC."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Container Insights. Null disables monitoring."
  type        = string
  default     = null
}

variable "enable_workload_identity" {
  description = "Enable Azure AD Workload Identity for pods."
  type        = bool
  default     = true
}

variable "enable_oidc_issuer" {
  description = "Enable the OIDC issuer endpoint (required for Workload Identity)."
  type        = bool
  default     = true
}

variable "maintenance_window" {
  description = "Optional maintenance window configuration."
  type = object({
    allowed = list(object({
      day   = string
      hours = list(number)
    }))
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the AKS cluster and default node pool."
  type        = map(string)
  default     = {}
}
