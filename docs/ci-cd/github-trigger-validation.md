# GitHub Cloud Build Trigger Validation

## Trigger
- Name: order-api-main-ci
- Event: Push to main
- Configuration: cloud-build/cloudbuild.yaml
- Service account: Dedicated Cloud Build CI service account

## Validation checklist
- [ ] GitHub push invokes Cloud Build
- [ ] Python tests pass
- [ ] Docker image builds successfully
- [ ] Artifact Registry receives the image
- [ ] Cloud Build reports SUCCESS

## Security
CI publishes container images without Kubernetes deployment permissions.
Production deployments use a separate deployment service account.
