/*
  A "google_project_iam_binding" only updates one particular role. If someone is added
  manually to that role (s)he will be removed when the Terraform config is applied.
  If someone is added to a role that is not listed in our Terraform config, that mapping
  will not be affected when the config is applied.

  The alternative would be to use the "google_project_iam_policy" resource which is
  "authoritative" on the project level meaning anything that is not in our Terraform
  config will be remove when it is applied. I think the risk of unintended consequences
  outweighs the extra security that will bring. Example: locking us out of the project
  or messing with Google controlled service accounts whose permissions are set up a bit
  under-the-hood.
*/


data "google_project" "current_project" {
}




# *********************** STORAGE ***********************
# to keep the terraform and main user separate
resource "google_project_iam_member" "svc_github_storage_admin" {
  project = data.google_project.current_project.id
  role    = "roles/storage.admin"
  # CI for data ingestion pipeline
  member = "serviceAccount:${google_service_account.svc_github_action_application_deployment.email}"
}


# ********************** DATAFLOW ************************
resource "google_project_iam_binding" "dataflow_admin" {
  project = data.google_project.current_project.id
  role    = "roles/dataflow.admin"
  members = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}

resource "google_project_iam_binding" "dataflow_worker" {
  project = data.google_project.current_project.id
  role    = "roles/dataflow.worker"
  members = [
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email)
  ]
}

# ******************* SECRET MANAGER *********************
resource "google_project_iam_binding" "secretmanager_admin" {
  project = data.google_project.current_project.id
  role    = "roles/secretmanager.admin"
  members = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email)
  ]
}


# *************************** PUB/SUB *******************************

resource "google_project_iam_binding" "pubsub_editor" {
  project = data.google_project.current_project.id
  role    = "roles/pubsub.editor"
  members = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email), # CI for data ingestion pipeline
  ]
}
