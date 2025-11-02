# Enable required Google APIs for GKE and networking features.
resource "google_project_service" "services" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

data "http" "caller_ip" {
  # Force IPv4 response so Master Authorized Networks receives a valid CIDR
  url = "https://ipv4.icanhazip.com"
}

locals {
  caller_ip_cidr = var.master_authorized_cidr != null ? var.master_authorized_cidr : "${trimspace(data.http.caller_ip.response_body)}/32"
}

# VPC with primary and secondary ranges sized for GKE.
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "primary" {
  name                     = "${var.network_name}-primary"
  ip_cidr_range            = var.subnet_primary
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.subnet_secondary_pods
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.subnet_secondary_services
  }
}

resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.primary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Private GKE cluster with Workload Identity and network policy enabled.
resource "google_container_cluster" "gke" {
  name                = var.cluster_name
  location            = var.zone
  deletion_protection = false

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.primary.self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  networking_mode = "VPC_NATIVE"

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # keep API endpoint public but restricted
    master_global_access_config { enabled = true }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = local.caller_ip_cidr
      display_name = "admin-ip"
    }
  }

  release_channel { channel = "REGULAR" }

  workload_identity_config { workload_pool = "${var.project_id}.svc.id.goog" }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    managed_prometheus { enabled = true }
  }

  network_policy {
    enabled  = var.enable_network_policy
    provider = "CALICO"
  }

  depends_on = [google_project_service.services]
}

# Managed node pool sized by module inputs.
resource "google_container_node_pool" "default" {
  name     = "default-pool"
  location = var.zone
  cluster  = google_container_cluster.gke.name

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.node_disk_size_gb
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    metadata = { disable-legacy-endpoints = "true" }
    tags     = ["gke-node"]
  }

  autoscaling {
    min_node_count = var.gke_min_nodes
    max_node_count = var.gke_max_nodes
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
