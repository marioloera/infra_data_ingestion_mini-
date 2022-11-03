# NOTE: Seems like the "Service Usage API" has to be enabled manually via the cloud console
# to bootstrap the whole thing. Add further services below.

resource "google_project_service" "iam_api" {
  service = "iam.googleapis.com"
}

resource "google_project_service" "dataflow_api" {
  service = "dataflow.googleapis.com"
}
