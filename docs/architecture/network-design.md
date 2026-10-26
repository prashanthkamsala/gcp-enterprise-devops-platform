# GCP Network Architecture

## Project
Enterprise GCP DevOps Platform

## Environment
- Cloud: Google Cloud Platform
- Region: us-east1
- Environment: dev
- Provisioning: Terraform

## Network Design

| Resource | Configuration |
|---|---|
| VPC | devops-lab-vpc |
| Subnet | devops-lab-subnet |
| Node CIDR | 10.20.0.0/24 |
| Pod CIDR | 10.21.0.0/18 |
| Service CIDR | 10.22.0.0/22 |

## Architecture Decisions

### Custom VPC
Provides explicit subnet and IP allocation control.

### Regional Routing
Uses REGIONAL dynamic routing mode.

### Secondary IP Ranges
Provides dedicated ranges for GKE Pods and Services.

### Private Google Access
Enables eligible resources without external IP addresses
to access supported Google APIs.

## Validation Evidence

- Terraform apply: 2 resources added
- VPC configuration verified using gcloud
- Subnet and secondary CIDRs verified using gcloud
- Terraform drift check: No changes

## Security

- No broad ingress firewall rules provisioned
- No public application endpoint deployed
- Terraform state excluded from Git
- Cloud IAM permissions should follow least privilege

## Teardown

Destroy resources using Terraform from
terraform/environments/dev after dependent
resources have been removed.
