
resource "google_container_registry" "registry" {
  location = "EU"
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.objectViewer"
  member = format("serviceAccount:%s", data.google_app_engine_default_service_account.default.email)
}
