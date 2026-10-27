variable "project_id" {
  description = "GCP project identifier"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "GKE deployment zone"
  type        = string
  default     = "us-east1-b"
}

variable "admin_cidr" {
  description = "Trusted developer public IPv4 CIDR"
  type        = string
}