variable "project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "zone" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "node_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "admin_cidr" {
  type        = string
  description = "Trusted public IPv4 CIDR permitted to access the GKE control plane"
}