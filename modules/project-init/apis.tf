# NOTE: Seems like the "Service Usage API" has to be enabled manually via the cloud console
# to bootstrap the whole thing. Add further services below.

resource "google_project_service" "serviceusage_api" {
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager_api" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "pubsub_api" {
  service = "pubsub.googleapis.com"
}

resource "google_project_service" "iam_api" {
  service = "iam.googleapis.com"
}

resource "google_project_service" "bigquery_api" {
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "datacatalog_api" {
  service = "datacatalog.googleapis.com"
}

resource "google_project_service" "ai_platform_api" {
  service = "ml.googleapis.com"
}

resource "google_project_service" "dataflow_api" {
  service = "dataflow.googleapis.com"
}

resource "google_project_service" "secretmanager_api" {
  service = "secretmanager.googleapis.com"
}

resource "google_project_service" "appengine_api" {
  service = "appengine.googleapis.com"
}

resource "google_project_service" "iap_api" {
  service = "iap.googleapis.com"
}


resource "google_project_service" "drive_api" {
  service = "drive.googleapis.com"
}
