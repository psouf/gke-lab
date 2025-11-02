module "gke" {
  source = "./modules/gke"

  project_id                = var.project_id
  region                    = var.region
  zone                      = var.zone
  network_name              = var.network_name
  subnet_primary            = var.subnet_primary
  subnet_secondary_pods     = var.subnet_secondary_pods
  subnet_secondary_services = var.subnet_secondary_services
  cluster_name              = var.cluster_name
  master_authorized_cidr    = var.master_authorized_cidr
  gke_min_nodes             = var.gke_min_nodes
  gke_max_nodes             = var.gke_max_nodes
  machine_type              = var.machine_type
  enable_network_policy     = var.enable_network_policy
  node_disk_size_gb         = var.node_disk_size_gb
}

module "argocd" {
  source = "./modules/argocd"

  providers = {
    kubernetes = kubernetes.gke
    helm       = helm.gke
  }

  depends_on = [module.gke]
}
