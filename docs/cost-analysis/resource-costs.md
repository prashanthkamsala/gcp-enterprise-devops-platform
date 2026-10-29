# GCP DevOps Platform — Cost and Cleanup

## Scope

Project: project-0732a8d8-67b9-48c8-a9d
Region: us-east1
GKE zone: us-east1-b

## Billable resources

- GKE Standard cluster and compute node
- Persistent disks and other GKE-associated resources
- Artifact Registry image storage
- Cloud Storage source bucket
- Cloud Storage Terraform state bucket
- Cloud Build execution
- Cloud Logging and Cloud Monitoring usage
- Applicable network traffic and other service charges

## Cost-control practices

1. Monitor billing during active project work.
2. Keep the GKE node pool small for this lab.
3. Avoid unnecessary Cloud Build executions.
4. Use scoped logging and monitoring configurations.
5. Remove billable resources after project validation.

## Teardown order

1. Capture final deployment and monitoring evidence.
2. Disable and delete the GitHub CI trigger.
3. Verify Terraform variables and state.
4. Generate and review the Terraform destroy plan.
5. Destroy Terraform-managed infrastructure.
6. Remove non-Terraform-managed Cloud Build repository links and connections.
7. Check for remaining GKE, compute, storage, and registry resources.
8. Retain Terraform state until resource deletion is verified.
9. Remove the state bucket only when no longer required.
10. Inspect Google Cloud Billing for residual usage.

## Important warnings

Never apply a Terraform plan that unexpectedly replaces existing
resources or points to an incorrect GCP project.

Never delete remote Terraform state before confirming that all
managed infrastructure has been destroyed.

GKE and associated compute resources can continue generating
charges while running.

## Actual spend

Record final spend from Google Cloud Billing after completion.
No estimated or unverified spend figures are included here.
