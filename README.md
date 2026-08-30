# terraform-aks (modules library)

Reusable Terraform modules for Azure Kubernetes Service (AKS), consumed by
the root Terraform codebase in the `terraform-aks-infra` Azure DevOps repo.

This repository contains **only modules** — no root `main.tf`, no
`terraform.tfvars`, no pipeline, and nothing environment-specific. Each
top-level folder is one independently reusable module:

| Module | Creates |
|---|---|
| `resource-group/` | The Azure resource group. |
| `networking/` | VNet, subnets, and per-subnet NSGs. |
| `managed-identity/` | A user-assigned managed identity plus optional role assignments. |
| `aks/` | The AKS cluster (control plane) and its default/system node pool. |
| `aks-node-pool/` | One additional (user) AKS node pool per module call. |
| `monitoring/` | A Log Analytics workspace for AKS Container Insights. |
| `acr/` | An Azure Container Registry. |

## How these modules are consumed

The infrastructure repo references each module by git source, pinned to a
branch or tag of this repository, e.g.:

```hcl
module "aks" {
  source = "git::https://github.com/clouddevopswithkrishna/terraform-aks.git//aks?ref=main"
  # ...
}
```

Because this repo is public, `terraform init` can fetch these modules over
plain `git clone` with no credentials, from a local machine or from the
Azure DevOps pipeline agent.

## Versioning

Referencing `?ref=main` means every `terraform init` in the infra repo
picks up the latest commit on this repo's `main` branch. For a more
production-safe setup, tag releases here (e.g. `git tag v1.0.0&& git push
--tags`) and change the infra repo's module `source` blocks to
`?ref=v1.0.0`, bumping that ref deliberately (via its own PR) when you want
the infra repo to pick up a module change.

## Making a module change

1. Branch, edit the relevant module folder, open a PR against `main` in
   this repo (this repo has no pipeline of its own — review is manual, or
   add one if you want `terraform validate`/`tflint` to run here too).
2. Merge.
3. In the `terraform-aks-infra` repo, bump the module `ref` (if pinned to a
   tag) or simply re-run `terraform init -upgrade` (if tracking `main`) so
   the infra pipeline picks up the change on its next plan/apply.
