output "namespace" {
  description = "Namespace where Argo CD was installed."
  value       = kubernetes_namespace.this.metadata[0].name
}

output "release_name" {
  description = "Helm release name for Argo CD."
  value       = helm_release.this.name
}
