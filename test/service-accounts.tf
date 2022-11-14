/*
  Service accounts are just defined here. Permissions are granted in project-policies.tf or
  when defining datasets and buckets.
*/

resource "google_service_account" "svc_dataflow_worker" {
  account_id = "svc-dataflow-worker"
}

resource "google_service_account" "svc_application_deployment" {
  # As opposed to the Terraform service account handling infrastructure
  account_id = "svc-application-deployment"
}

# Service accounts used by data producers to publish data for the data lake to Pub/Sub
# Prefer using this common account, the two accounts above were created before we figured out
# that there is no real need for each service to have its own account.
resource "google_service_account" "svc_data_lake_producer" {
  account_id = "svc-data-lake-producer"
}
