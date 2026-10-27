resource "google_artifact_registry_repository" "app_images" {
  project       = var.project_id
  location      = var.region
  repository_id = "devops-app-images"
  format        = "DOCKER"
  description   = "Private images for Enterprise DevOps Platform"

  docker_config {
    immutable_tags = true
  }
}

resource "google_artifact_registry_repository_iam_member" "gke_pull" {
  project    = var.project_id
  location   = google_artifact_registry_repository.app_images.location
  repository = google_artifact_registry_repository.app_images.repository_id

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${module.gke.node_service_account}"
}