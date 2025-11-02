############################################
# Google providers
############################################
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Access token from your gcloud ADC
data "google_client_config" "default" {}

############################################
# Kubernetes / Helm providers bound to GKE
# Use aliases so resources can target them explicitly
############################################
provider "kubernetes" {
  alias                  = "gke"
  host                   = "https://${module.gke.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  alias = "gke"
  kubernetes = {
    host                   = "https://${module.gke.cluster_endpoint}"
    cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}
