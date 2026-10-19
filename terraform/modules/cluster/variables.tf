variable "cluster_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "k8s_version" {
  type    = string
  default = "v1.27.3"
}
