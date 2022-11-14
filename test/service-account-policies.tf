# As Dataflow jobs are launched from Cloud Composer (merchant job) and GitHub Actions
# (data ingestion pipeline) these service accounts need permission to launch Compute Engine
# instances using the Dataflow worker svc account.
resource "google_service_account_iam_binding" "svc_dataflow_worker_user" {
  service_account_id = google_service_account.svc_dataflow_worker.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    format("serviceAccount:%s", google_service_account.svc_application_deployment.email),
  ]
}

resource "google_project_iam_member" "svc_compute_user" {
  project = data.google_project.current_project.id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.svc_application_deployment.email}"
}
