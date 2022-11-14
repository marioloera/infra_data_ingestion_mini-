# The rationale for having these two parallel environments is that the Phoenix microservices
# need two separate environments for System Integration and Staging. In our case, it doesn't really
# make sense to create a whole new project just for Staging so we deploy both the pipelines and
# the buckets/datasets/topics they need in turing-app-367309.

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
  schema_registry_svc_account        = google_service_account.svc_application_deployment.email
  schema_registry_bucket             = "${data.google_project.current_project.project_id}-avro-schema-store-sysint"
  application_deployment_svc_account = google_service_account.svc_application_deployment.email
  datalake_avro_bucket               = "${data.google_project.current_project.project_id}-data-lake-avro"
  unprocessed_bucket                 = "${data.google_project.current_project.project_id}-beam-pubsub-unprocessed-sysint"
  dataflow_temp_bucket               = "${data.google_project.current_project.project_id}-dataflow-temp-sysint"
  datalake_dataset                   = "data_lake_sysint"
  pubsub_publishers = [

  ]
  data_viewers = [

  ]
  schema_viewers = [

  ]
}
