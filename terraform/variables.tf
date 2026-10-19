variable "cluster_name" {
  description = "Name of the local Kind cluster"
  type        = string
  default     = "status-page"
}

variable "namespace" {
  description = "Kubernetes namespace for the workload"
  type        = string
  default     = "status-page"
}

variable "k8s_version" {
  description = "Kubernetes version for the Kind node"
  type        = string
  default     = "v1.27.3"
}
