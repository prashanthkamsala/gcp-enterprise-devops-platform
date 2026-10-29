# Dedicated identity for deploying Order API to GKE.
resource "google_service_account" "cloud_deploy" {
  project      = var.project_id
  account_id   = "devops-cloud-deploy-sa"
  display_name = "DevOps GKE Deployment Service Account"
  description  = "Deploys Order API to GKE through Helm"
}

# Allows retrieval of GKE cluster connection information.
# Does not grant Kubernetes workload modification rights.
resource "google_project_iam_member" "cloud_deploy_cluster_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "serviceAccount:${google_service_account.cloud_deploy.email}"
}

# Allows deployment job logs to be written to Cloud Logging.
resource "google_project_iam_member" "cloud_deploy_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_deploy.email}"
}

# Allows the deployment job to download its source files.
resource "google_storage_bucket_iam_member" "cloud_deploy_source_reader" {
  bucket = google_storage_bucket.cloud_build_source.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloud_deploy.email}"
}