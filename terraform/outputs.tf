output "cluster_name" {
  description = "Kind cluster name"
  value       = kind_cluster.this.name
}

output "namespace" {
  description = "Namespace created for the workload"
  value       = kubernetes_namespace.this.metadata[0].name
}

output "endpoint" {
  description = "Kubernetes API endpoint"
  value       = kind_cluster.this.endpoint
  sensitive   = true
}
