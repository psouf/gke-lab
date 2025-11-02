variable "project_id" {
  description = "Google Cloud project ID where all resources will be created."
  type        = string
}

variable "region" {
  description = "Default GCP region used for regional resources (VPC, subnet, NAT)."
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone for the zonal GKE cluster and node pool."
  type        = string
  default     = "europe-west1-b"
}

variable "network_name" {
  description = "Name of the custom VPC created for the cluster."
  type        = string
  default     = "tf-secure-vpc"
}

variable "subnet_primary" {
  description = "Primary subnet CIDR used for GKE nodes."
  type        = string
  default     = "10.10.0.0/20"
}

variable "subnet_secondary_pods" {
  description = "Secondary subnet CIDR dedicated to pod IP addresses."
  type        = string
  default     = "10.20.0.0/14"
}

variable "subnet_secondary_services" {
  description = "Secondary subnet CIDR dedicated to Kubernetes service IPs."
  type        = string
  default     = "10.30.0.0/20"
}

variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
  default     = "tf-gke-private"
}

variable "master_authorized_cidr" {
  description = "CIDR allowed to reach the GKE control plane (your public IPv4/32). Leave null to auto-detect."
  type        = string
  default     = null # auto-detected at apply time if null
}

variable "gke_min_nodes" {
  description = "Minimum number of nodes in the managed node pool."
  type        = number
  default     = 2
}

variable "gke_max_nodes" {
  description = "Maximum number of nodes in the managed node pool."
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for GKE nodes."
  type        = string
  default     = "e2-standard-4"
}

variable "enable_network_policy" {
  description = "Enable Kubernetes network policy (Calico) on the cluster."
  type        = bool
  default     = true
}

variable "node_disk_size_gb" {
  description = "Boot disk size in GB for each GKE node."
  type        = number
  default     = 20
}
