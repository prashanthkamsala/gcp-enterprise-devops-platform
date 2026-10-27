# Order API Deployment Runbook

## Environment
- Platform: GKE Standard
- Cluster: devops-lab-gke
- Zone: us-east1-b
- Namespace: order-platform
- Release: order-api
- Deployment method: Helm
- Registry: Google Artifact Registry

## Deployment
helm upgrade --install order-api \
  kubernetes/helm/order-platform \
  --namespace order-platform \
  --create-namespace \
  --wait --timeout 5m

## Verification
kubectl get pods -n order-platform
kubectl rollout status deployment/order-api -n order-platform
helm status order-api -n order-platform

## Access
kubectl port-forward -n order-platform svc/order-api 8081:80

## Troubleshooting
kubectl describe pods -n order-platform
kubectl logs -n order-platform deployment/order-api
kubectl get events -n order-platform --sort-by=.metadata.creationTimestamp

## Rollback
helm history order-api -n order-platform
helm rollback order-api REVISION -n order-platform

## Limitations
- Single GKE worker node
- Single application replica
- In-memory order storage
- Not designed for multi-zone high availability
