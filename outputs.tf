output "cluster_name" {
  description = "Name of the provisioned GKE cluster."
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint used by kubectl to reach the control plane."
  value       = module.gke.cluster_endpoint
}

output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = module.argocd.namespace
}

output "argocd_release_name" {
  description = "Helm release name used for Argo CD."
  value       = module.argocd.release_name
}

output "gke_credentials_command" {
  description = "Helper command to configure kubectl credentials for the cluster."
  value       = local.gke_credentials_command
}
