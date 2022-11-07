# As Dataflow jobs are launched from Cloud Composer (merchant job) and GitHub Actions
# (data ingestion pipeline) these service accounts need permission to launch Compute Engine
# instances using the Dataflow worker svc account.
resource "google_service_account_iam_binding" "svc_dataflow_worker_user" {
  service_account_id = google_service_account.svc_dataflow_worker.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}
