output "cluster_name" {
  description = "Name of the created GKE cluster."
  value       = google_container_cluster.gke.name
}

output "cluster_endpoint" {
  description = "Public endpoint URL for the GKE control plane."
  value       = google_container_cluster.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded cluster CA certificate used by kubectl/Helm."
  value       = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
}

output "network_name" {
  description = "Name of the VPC attached to the cluster."
  value       = google_compute_network.vpc.name
}

output "subnetwork_name" {
  description = "Name of the primary subnet used by the nodes."
  value       = google_compute_subnetwork.primary.name
}
