# The rationale for having these two parallel environments is that the Phoenix microservices
# need two separate environments for System Integration and Staging. In our case, it doesn't really
# make sense to create a whole new project just for Staging so we deploy both the pipelines and
# the buckets/datasets/topics they need in trustly-data-services-test.

#   _____           _____       _
#  / ____|         |_   _|     | |
# | (___  _   _ ___  | |  _ __ | |_
#  \___ \| | | / __| | | | '_ \| __|
#  ____) | |_| \__ \_| |_| | | | |_
# |_____/ \__, |___/_____|_| |_|\__|
#          __/ |
#         |___/
module "data_pipeline" {
  source = "../modules/infra-data-ingestion"

  project                            = data.google_project.current_project.id
  dataflow_worker                    = google_service_account.svc_dataflow_worker.email
  schema_registry_svc_account        = google_service_account.svc_github_action_avro_schema_registry.email
  schema_registry_bucket             = "trustly-data-services-test-avro-schema-store-sysint"
  application_deployment_svc_account = google_service_account.svc_github_action_application_deployment.email
  datalake_avro_bucket               = "trustly-data-services-test-data-lake-avro"
  unprocessed_bucket                 = "trustly-data-services-test-beam-pubsub-unprocessed-sysint"
  dataflow_temp_bucket               = "trustly-data-services-test-dataflow-temp-sysint"
  datalake_dataset                   = "data_lake_sysint"
  pubsub_publishers = [
    format("serviceAccount:%s", google_service_account.svc_pubsub_checkout_mon.email),
    format("serviceAccount:%s", google_service_account.svc_pubsub_deposit_service.email),
    format("serviceAccount:%s", google_service_account.svc_data_lake_producer.email),
  ]
  data_viewers = [
    "group:team.analytics@trustly.com",
    "group:team.businessintelligence@trustly.com",
    "group:team.tech@trustly.com",
    "serviceAccount:svc-dbt@trustly-bi-finance-test.iam.gserviceaccount.com",
    "serviceAccount:svc-dbt@trustly-bi-finance-prod.iam.gserviceaccount.com",
    "serviceAccount:svc-ab-test@trustly-data-services-test.iam.gserviceaccount.com",
  ]
  schema_viewers = [
    "group:team.tech@trustly.com"
  ]
}

resource "google_pubsub_topic_iam_member" "phoenix_analytics_avro_viewer_tech" {
  topic  = module.data_pipeline.topic_name
  role   = "roles/viewer"
  member = "group:team.tech@trustly.com"
}

#   _____ _              _
#  / ____| |            (_)
# | (___ | |_ __ _  __ _ _ _ __   __ _
#  \___ \| __/ _` |/ _` | | '_ \ / _` |
#  ____) | || (_| | (_| | | | | | (_| |
# |_____/ \__\__,_|\__, |_|_| |_|\__, |
#                   __/ |         __/ |
#                  |___/         |___/
module "data_pipeline_staging" {
  source = "../modules/infra-data-ingestion"

  project                            = data.google_project.current_project.id
  dataflow_worker                    = google_service_account.svc_dataflow_worker.email
  schema_registry_svc_account        = google_service_account.svc_github_action_avro_schema_registry.email
  schema_registry_bucket             = "trustly-data-services-test-avro-schema-store-staging"
  application_deployment_svc_account = google_service_account.svc_github_action_application_deployment.email
  datalake_avro_bucket               = "trustly-data-services-test-data-lake-avro-staging"
  unprocessed_bucket                 = "trustly-data-services-test-beam-pubsub-unprocessed-staging"
  dataflow_temp_bucket               = "trustly-data-services-test-dataflow-temp-staging"
  datalake_dataset                   = "data_lake_staging"
  data_viewers = [
    "group:team.analytics@trustly.com",
    "group:team.tech@trustly.com",
  ]
  schema_viewers = [
    "group:team.tech@trustly.com"
  ]
  pubsub_publishers = [
    format("serviceAccount:%s", google_service_account.svc_pubsub_checkout_mon.email),
    format("serviceAccount:%s", google_service_account.svc_pubsub_deposit_service.email),
    format("serviceAccount:%s", google_service_account.svc_data_lake_producer.email),
  ]
  topic_name            = "phoenix.analytics.avro.staging"
  subscription_gcs_name = "beam-to-gcs-staging"
  subnet_cidr_range     = "10.2.0.0/20"
  network_name          = "dataflow-network-staging"
  subnetwork_name       = "dataflow-subnetwork-staging"
}

resource "google_pubsub_topic_iam_member" "phoenix_analytics_avro_viewer_tech_staging" {
  topic  = module.data_pipeline_staging.topic_name
  role   = "roles/viewer"
  member = "group:team.tech@trustly.com"
}
