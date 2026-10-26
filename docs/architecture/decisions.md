# Architecture Decision Records

## ADR-001: Infrastructure as Code

Decision: Use Terraform to provision GCP resources.

Reason:
- Reproducible environments
- Peer-reviewable infrastructure changes
- Version-controlled configuration
- Controlled infrastructure teardown

## ADR-002: Kubernetes deployment management

Decision: Use Helm for application releases on GKE.

Reason:
- Reusable deployment templates
- Environment-specific configuration
- Release history and rollback support

## ADR-003: Repository workflow

Decision: Use main and short-lived feature branches.

Reason:
- Isolated changes
- Pull request review
- Easier rollback and auditing

## ADR-004: Non-production environment

Decision: Build a disposable lab environment.

Reason:
- Control free-trial consumption
- Safely simulate application failures
- Recreate infrastructure from source code
