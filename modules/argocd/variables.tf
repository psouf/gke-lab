variable "namespace" {
  description = "Kubernetes namespace where Argo CD is installed."
  type        = string
  default     = "argocd"
}

variable "release_name" {
  description = "Name of the Helm release."
  type        = string
  default     = "argo-cd"
}

variable "chart" {
  description = "Helm chart name."
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Helm chart version to deploy."
  type        = string
  default     = "6.9.3"
}

variable "helm_repository" {
  description = "Helm repository URL for the Argo CD chart."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "values_override" {
  description = "Override values merged with default Argo CD demo settings."
  type        = map(any)
  default     = {}
}
