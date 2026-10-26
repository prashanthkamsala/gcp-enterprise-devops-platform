variable "network_name" {
  description = "Name of the custom VPC"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "node_cidr" {
  description = "Primary subnet range for nodes"
  type        = string
}

variable "pod_cidr" {
  description = "Secondary range for GKE Pods"
  type        = string
}

variable "service_cidr" {
  description = "Secondary range for GKE Services"
  type        = string
}