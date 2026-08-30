variable "name" {
  description = "Name of the node pool (max 12 chars, alphanumeric)."
  type        = string
}

variable "aks_cluster_id" {
  description = "Resource ID of the AKS cluster to attach this node pool to."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for this node pool."
  type        = string
}

variable "vm_size" {
  description = "VM SKU for nodes in this pool."
  type        = string
}

variable "orchestrator_version" {
  description = "Kubernetes version for this node pool. Defaults to the cluster version when null."
  type        = string
  default     = null
}

variable "os_type" {
  description = "Linux or Windows."
  type        = string
  default     = "Linux"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 128
}

variable "mode" {
  description = "System or User node pool mode."
  type        = string
  default     = "User"
}

variable "max_pods" {
  description = "Maximum pods per node."
  type        = number
  default     = 30
}

variable "availability_zones" {
  description = "Availability zones for this node pool."
  type        = list(string)
  default     = []
}

variable "enable_auto_scaling" {
  description = "Enable the cluster autoscaler for this node pool."
  type        = bool
  default     = true
}

variable "node_count" {
  description = "Fixed node count when autoscaling is disabled."
  type        = number
  default     = 1
}

variable "min_count" {
  description = "Minimum node count when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum node count when autoscaling is enabled."
  type        = number
  default     = 3
}

variable "node_labels" {
  description = "Kubernetes node labels."
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "Kubernetes node taints, e.g. [\"workload=batch:NoSchedule\"]."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the node pool."
  type        = map(string)
  default     = {}
}
