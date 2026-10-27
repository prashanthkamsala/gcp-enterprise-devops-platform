resource "google_service_account" "gke_nodes" {
  project      = var.project_id
  account_id   = "devops-gke-node-sa"
  display_name = "DevOps Lab GKE Node Identity"
}

resource "google_project_iam_member" "node_role" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "cluster" {
  name                      = var.cluster_name
  location                  = var.zone
  default_max_pods_per_node = 32


  network    = var.network_id
  subnetwork = var.subnet_id

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.admin_cidr
      display_name = "developer-workstation"
    }
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  enable_shielded_nodes = true

  deletion_protection = false
}

resource "google_container_node_pool" "primary" {
  name       = "devops-primary-pool"
  location   = var.zone
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  node_config {
    machine_type    = var.node_machine_type
    disk_size_gb    = 30
    disk_type       = "pd-standard"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    labels = {
      environment = "dev"
      project     = "devops-lab"
    }
  }

  depends_on = [
    google_project_iam_member.node_role
  ]
}