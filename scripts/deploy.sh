#!/usr/bin/env bash
set -euo pipefail

CLUSTER="status-page"
NS="status-page"
IMAGE="status-page:local"

echo "==> Building image"
docker build -t "$IMAGE" app/

echo "==> Provisioning cluster (Terraform)"
cd terraform
terraform init -input=false
terraform apply -auto-approve -input=false
cd ..

echo "==> Loading image into Kind"
kind load docker-image "$IMAGE" --name "$CLUSTER"

echo "==> Applying manifests"
kubectl apply -f k8s/ -n "$NS"

echo "==> Waiting for rollout"
kubectl rollout status deployment/status-page -n "$NS" --timeout=60s

echo "==> Pods"
kubectl get pods -n "$NS"

echo
echo "Open: kubectl port-forward -n $NS svc/status-page 8080:80"
