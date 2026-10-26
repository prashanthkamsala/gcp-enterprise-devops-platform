variable "project_id" {
  description = "GCP project identifier"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
  default     = "us-east1"
}