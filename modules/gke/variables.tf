variable "project_id" {
  description = "Google Cloud project ID used by the module."
  type        = string
}

variable "region" {
  description = "Region for regional Google Cloud resources."
  type        = string
}

variable "zone" {
  description = "Zone where the zonal GKE cluster is created."
  type        = string
}

variable "network_name" {
  description = "Name assigned to the custom VPC."
  type        = string
}

variable "subnet_primary" {
  description = "Primary subnet CIDR for GKE nodes."
  type        = string
}

variable "subnet_secondary_pods" {
  description = "Secondary subnet CIDR used for pod IPs."
  type        = string
}

variable "subnet_secondary_services" {
  description = "Secondary subnet CIDR used for service IPs."
  type        = string
}

variable "cluster_name" {
  description = "Name for the GKE cluster."
  type        = string
}

variable "master_authorized_cidr" {
  description = "Authorized IPv4 CIDR (or null to auto-detect an IPv4 /32)."
  type        = string
  default     = null
}

variable "gke_min_nodes" {
  description = "Minimum node count configured in the managed node pool."
  type        = number
}

variable "gke_max_nodes" {
  description = "Maximum node count configured in the managed node pool."
  type        = number
}

variable "machine_type" {
  description = "Machine type used for the GKE nodes."
  type        = string
}

variable "enable_network_policy" {
  description = "Toggle for Kubernetes network policy (Calico)."
  type        = bool
}

variable "node_disk_size_gb" {
  description = "Boot disk size (GB) for each node in the node pool."
  type        = number
}
