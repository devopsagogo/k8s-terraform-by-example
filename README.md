
# k8s-terraform-by-example

**Kubernetes and Terraform by example — a working status page on Kind, provisioned by IaC, verified by CI.**

![ci](https://img.shields.io/github/actions/workflow/status/devopsagogo/k8s-terraform-by-example/ci.yml?style=flat-square&label=ci)
![terraform](https://img.shields.io/badge/terraform-%E2%89%A51.5-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![kubernetes](https://img.shields.io/badge/kubernetes-%E2%89%A51.27-326CE5?style=flat-square&logo=kubernetes&logoColor=white)


## What this is

A minimal status-page service deployed to a local Kubernetes cluster.
Terraform provisions the cluster and namespace; `kubectl` deploys the app
into it. One command spins everything up. CI validates the Terraform and
dry-runs the manifests on every push.

## Architecture

```text
k8s-terraform-by-example/
├── app/
│   ├── server.py
│   └── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── scripts/deploy.sh
├── docs/DECISIONS.md
└── .github/workflows/ci.yml
```

## Quick start

```bash
./scripts/deploy.sh
kubectl port-forward -n status-page svc/status-page 8080:80
```

Or with make:

```bash
make up
make down
```

## Helm

The same app is also packaged as a Helm chart in `helm/status-page/`:

```bash
helm install status-page helm/status-page -n status-page
```

The raw manifests in `k8s/` are the reference implementation.
The chart shows the same resources expressed as a parameterized package.

## Design decisions

See docs/DECISIONS.md. Kind for CI speed, explicit namespace, ClusterIP
because local, requests and limits both, readiness vs liveness separate.

## What I'd change at scale

- Terraform backend — remote state in S3 with DynamoDB locking
- Cluster — EKS/GKE instead of Kind
- Delivery — GitOps (ArgoCD/Flux)
- Ingress — ingress controller instead of port-forward
- Packaging — Helm or Kustomize at 10+ services
- Secrets — a secrets manager, never plain env vars

This repo is a demo. The pieces are real, the decisions are justified,
and the production path is explicit.

## License

MIT