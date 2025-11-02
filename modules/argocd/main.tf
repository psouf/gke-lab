# Namespace for Argo CD resources.
resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

locals {
  # Minimal demo values to expose the Argo CD UI without TLS; merge with user overrides.
  default_values = {
    configs = {
      params = { "server.insecure" = true }
    }
    server = {
      extraArgs = ["--insecure"]
    }
  }
}

# Deploy Argo CD from the official Helm chart.
resource "helm_release" "this" {
  name       = var.release_name
  repository = var.helm_repository
  chart      = var.chart
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = var.chart_version

  values = [
    jsonencode(merge(local.default_values, var.values_override))
  ]
}
