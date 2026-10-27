terraform {
  backend "gcs" {
    bucket = "devops-tfstate-project-0732a8d8-67b9-48c8-a9d"
    prefix = "enterprise-devops/dev"
  }
}