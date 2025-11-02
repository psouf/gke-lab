# GKE Lab

Terraform configuration that builds a private GKE Standard cluster with supporting network resources and installs Argo CD via Helm. The stack is split into reusable modules to keep the root configuration small:

```
gke-lab/
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── locals.tf
└── modules/
    ├── gke/
    └── argocd/
```

## Prerequisites
- Google Cloud project with billing enabled.
- `gcloud` CLI authenticated (`gcloud auth application-default login`) and quota project set if required.
- Terraform ≥ 1.5.0 (see `versions.tf`).

## 1. Configure variables
Create `terraform.tfvars` in the repo root (same folder as `main.tf`):

```hcl
project_id = "<YOUR_PROJECT_ID>"
region     = "europe-west1"
zone       = "europe-west1-b"

# Optional overrides:
# master_authorized_cidr = "X.X.X.X/32"  # must be IPv4; auto-detected if omitted
# gke_min_nodes          = 2
# gke_max_nodes          = 2
# node_disk_size_gb      = 20
```

## 2. Deploy
```bash
terraform init
terraform apply
```

`module.gke` enables the required Google APIs, creates the VPC, Cloud NAT, and a private GKE cluster with two nodes by default. `module.argocd` installs Argo CD into the new cluster using the `helm.gke` provider alias.

> If your public IP is IPv6-only, set `master_authorized_cidr` manually—the auto-detect helper fetches an IPv4 address from `https://ipv4.icanhazip.com`.

## 3. Connect with kubectl
Use the helper output (`terraform output gke_credentials_command`) or run:

```bash
# Install gke-gcloud-auth-plugin once if prompted:
#   gcloud components install gke-gcloud-auth-plugin
#   # or: brew install gke-gcloud-auth-plugin
gcloud container clusters get-credentials tf-gke-private --zone europe-west1-b --project <YOUR_PROJECT_ID>
kubectl get nodes -o wide
```

## 4. Argo CD access
Ingress installation was removed; Argo CD is exposed only inside the cluster. To reach the UI, use a `kubectl port-forward`:

```bash
kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:80
open http://localhost:8080
```

Retrieve the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

## 5. Destroy
```bash
terraform destroy
```

Because `module.gke` sets `deletion_protection = false`, Terraform can delete the cluster during destroy.

## Customization
- Adjust node count, machine type, or disk size in `terraform.tfvars` (`gke_min_nodes`, `gke_max_nodes`, `machine_type`, `node_disk_size_gb`).
- Override Argo CD Helm values via the `values_override` map when calling `module.argocd`.
- Add more application modules under `modules/` and instantiate them from `main.tf`.
