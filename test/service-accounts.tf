/*
  Service accounts are just defined here. Permissions are granted in project-policies.tf or
  when defining datasets and buckets.
*/
resource "google_service_account" "svc_bi_etl" {
  account_id = "svc-bi-etl"
}

resource "google_service_account" "svc_qliksense" {
  account_id = "svc-qliksense"
}

resource "google_service_account" "svc_composer_worker" {
  account_id = "svc-composer-worker"
}

resource "google_service_account" "svc_dataflow_worker" {
  account_id = "svc-dataflow-worker"
}

resource "google_service_account" "svc_paywithmybank" {
  account_id = "svc-paywithmybank"
}

resource "google_service_account" "svc_github_action_application_deployment" {
  # As opposed to the Terraform service account handling infrastructure
  account_id = "svc-application-deployment"
}

resource "google_service_account" "svc_github_action_data_science_deployment" {
  account_id = "svc-data-science-deployment"
}

resource "google_service_account" "svc_github_action_avro_schema_registry" {
  # Used by the TrustylDev/data-lake-message-schema-avro CD job
  account_id = "svc-avro-schema-registry"
}

resource "google_service_account" "svc_kafka_connect" {
  account_id = "svc-kafka-connect"
}

resource "google_service_account" "svc_dbt" {
  account_id = "svc-dbt"
}

resource "google_service_account" "svc_app_engine" {
  account_id = "svc-app-engine"
}

# Service accounts used by data producers to publish data for the data lake to Pub/Sub
resource "google_service_account" "svc_pubsub_checkout_mon" {
  account_id = "svc-pubsub-checkout-mon"
}

resource "google_service_account" "svc_pubsub_deposit_service" {
  account_id = "svc-pubsub-deposit-service"
}

# Prefer using this common account, the two accounts above were created before we figured out
# that there is no real need for each service to have its own account.
resource "google_service_account" "svc_data_lake_producer" {
  account_id = "svc-data-lake-producer"
}

resource "google_service_account" "svc_airbyte" {
  account_id = "svc-airbyte"
}

resource "google_service_account" "svc_ab_test" {
  account_id = "svc-ab-test"
}
