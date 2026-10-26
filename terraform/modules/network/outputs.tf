output "network_id" {
  description = "Created VPC network ID"
  value       = google_compute_network.vpc.id
}

output "subnet_id" {
  description = "Created subnet ID"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "Created subnet name"
  value       = google_compute_subnetwork.subnet.name
}