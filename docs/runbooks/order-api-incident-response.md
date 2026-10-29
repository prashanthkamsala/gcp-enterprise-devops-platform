# Order API — Incident Response Runbook

## 1. Overview

Application: Order API
Platform: Google Kubernetes Engine (GKE)
Cluster: devops-lab-gke
Region/zone: us-east1 / us-east1-b
Namespace: order-platform
Deployment: order-api

Monitoring:
- Cloud Logging for container logs
- Cloud Monitoring for Kubernetes metrics
- Alert: Order API - Unexpected Container Restarts

## 2. Alert condition

The alert evaluates changes in the cumulative
Kubernetes container restart count over a 5-minute window.

A detected restart requires investigation. A restart
does not necessarily indicate an ongoing outage.

## 3. Initial investigation

Set the project:

    PROJECT_ID=$(gcloud config get-value project)

Refresh Kubernetes credentials:

    gcloud container clusters get-credentials devops-lab-gke --project="$PROJECT_ID" --zone=us-east1-b

Check application health:

    kubectl get deployment,pods -n order-platform

    kubectl rollout status deployment/order-api -n order-platform --timeout=120s

Inspect container restarts:

    kubectl get pods -n order-platform

Investigate Kubernetes events:

    kubectl get events -n order-platform --sort-by=.lastTimestamp

Inspect recent logs:

    kubectl logs deployment/order-api -n order-platform --tail=100

Investigate a restarted container:

    kubectl logs POD_NAME -n order-platform --previous --tail=100

Replace POD_NAME with the affected Pod name.

## 4. Cloud Logging investigation

Query application logs:

    gcloud logging read 'resource.type="k8s_container" AND resource.labels.namespace_name="order-platform"' --project="$PROJECT_ID" --freshness=1h --limit=50

Look for:
- Application exceptions
- Out-of-memory errors
- Failed health checks
- Dependency failures
- Repeated process crashes

## 5. Troubleshooting guide

CrashLoopBackOff:
- Inspect application startup logs
- Check ConfigMap and environment settings
- Check startup and liveness probe configuration

OOMKilled:
- Inspect Pod termination reason
- Review memory requests and limits
- Check container memory usage in Cloud Monitoring

ImagePullBackOff:
- Verify the image digest
- Verify Artifact Registry permissions
- Verify the image exists

Readiness probe failures:
- Inspect application logs
- Verify /health/ready
- Check CPU and memory pressure

## 6. Recovery

If a new release caused the failure, inspect Helm history:

    helm history order-api -n order-platform

Identify a known-good revision before rollback.

Rollback only when authorized:

    helm rollback order-api REVISION -n order-platform --wait --timeout 5m

Verify recovery:

    kubectl rollout status deployment/order-api -n order-platform --timeout=180s

    kubectl get pods -n order-platform

Do not repeatedly restart Pods without investigating the cause.

## 7. Data persistence warning

The current Order API stores orders in memory.

Pod restarts, replacements and rollbacks can lose order data.
The application is a demonstration workload, not a durable
production order-management service.

## 8. Incident closure

Record:
- Alert time and incident duration
- Impacted components
- Root cause
- Remediation
- Image digest and Helm revision
- Preventive actions

Confirm that the application is healthy and the incident
has recovered before closing the incident report.

## 9. Security

- Do not expose Kubernetes credentials or service account keys.
- Do not paste sensitive customer data into incident reports.
- Use least-privilege access for investigations.
- Keep Kubernetes control-plane access restricted.
