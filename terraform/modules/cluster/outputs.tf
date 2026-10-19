output "cluster_name" {
  value = kind_cluster.this.name
}

output "namespace" {
  value = kubernetes_namespace.this.metadata[0].name
}

output "endpoint" {
  value     = kind_cluster.this.endpoint
  sensitive = true
}
