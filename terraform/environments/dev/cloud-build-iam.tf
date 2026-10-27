# Identity used by Cloud Build for application CI.
resource "google_service_account" "cloud_build" {
  project      = var.project_id
  account_id   = "devops-cloud-build-sa"
  display_name = "DevOps Cloud Build CI Service Account"
  description  = "Runs tests, builds images and publishes to Artifact Registry"
}

# Allow CI to publish images only to our application repository.
resource "google_artifact_registry_repository_iam_member" "cloud_build_writer" {
  project    = var.project_id
  location   = google_artifact_registry_repository.app_images.location
  repository = google_artifact_registry_repository.app_images.repository_id

  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.cloud_build.email}"
}

# Allow CI to write build execution logs.
resource "google_project_iam_member" "cloud_build_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

# Store source archives submitted to Cloud Build.
resource "google_storage_bucket" "cloud_build_source" {
  project                     = var.project_id
  name                        = "devops-cb-source-${var.project_id}"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true

  versioning {
    enabled = false
  }
}

# The build identity needs to download source archives.
resource "google_storage_bucket_iam_member" "cloud_build_source_reader" {
  bucket = google_storage_bucket.cloud_build_source.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloud_build.email}"
}