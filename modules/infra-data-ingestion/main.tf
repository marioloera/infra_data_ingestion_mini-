data "google_project" "current_project" {
}


#  _______          _
# |__   __|        (_)
#    | | ___  _ __  _  ___
#    | |/ _ \| '_ \| |/ __|
#    | | (_) | |_) | | (__
#    |_|\___/| .__/|_|\___|
#            | |
#            |_|
resource "google_pubsub_topic" "data_ingestion_topic" {
  name = var.topic_name
}

resource "google_pubsub_topic_iam_binding" "publishers" {
  topic   = google_pubsub_topic.data_ingestion_topic.name
  role    = "roles/pubsub.publisher"
  members = var.pubsub_publishers
}

#   _____       _                   _       _   _
#  / ____|     | |                 (_)     | | (_)
# | (___  _   _| |__  ___  ___ _ __ _ _ __ | |_ _  ___  _ __
#  \___ \| | | | '_ \/ __|/ __| '__| | '_ \| __| |/ _ \| '_ \
#  ____) | |_| | |_) \__ \ (__| |  | | |_) | |_| | (_) | | | |
# |_____/ \__,_|_.__/|___/\___|_|  |_| .__/ \__|_|\___/|_| |_|
#                                    | |
#                                    |_|


# Set up a second subscription for the Avro to GCS pipeline (to be run in parallel)
resource "google_pubsub_subscription" "data_ingestion_subscription_avro_gcs" {
  name  = var.subscription_gcs_name
  topic = google_pubsub_topic.data_ingestion_topic.name

  expiration_policy {
    ttl = "" # Never expire
  }

  enable_message_ordering = false
}

resource "google_pubsub_subscription_iam_binding" "phoenix_analytics_avro_beam_avro_gcs_subscriber" {
  subscription = google_pubsub_subscription.data_ingestion_subscription_avro_gcs.id
  role         = "roles/pubsub.subscriber"
  members = [
    format("serviceAccount:%s", var.dataflow_worker)
  ]
}

resource "google_pubsub_subscription_iam_binding" "phoenix_analytics_avro_beam_avro_gcs_viewer" {
  subscription = google_pubsub_subscription.data_ingestion_subscription_avro_gcs.id
  role         = "roles/pubsub.viewer"
  members = [
    format("serviceAccount:%s", var.dataflow_worker)
  ]
}

#  ____             _        _
# |  _ \           | |      | |
# | |_) |_   _  ___| | _____| |_ ___
# |  _ <| | | |/ __| |/ / _ \ __/ __|
# | |_) | |_| | (__|   <  __/ |_\__ \
# |____/ \__,_|\___|_|\_\___|\__|___/

# ##### Bucket to keep the schemas published by a GitHub Action in TrustlyDev/data-lake-message-schema-avro
resource "google_storage_bucket" "schema_registry_bucket" {
  name                        = var.schema_registry_bucket
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "schema_registry_bucket_object_admin" {
  bucket = google_storage_bucket.schema_registry_bucket.name
  role   = "roles/storage.objectAdmin"
  member = format("serviceAccount:%s", var.schema_registry_svc_account)
}

resource "google_storage_bucket_iam_binding" "schema_registry_bucket_object_viewer_binding" {
  bucket = google_storage_bucket.schema_registry_bucket.name
  role   = "roles/storage.objectViewer"
  members = concat(
    [format("serviceAccount:%s", var.dataflow_worker)],
    var.schema_viewers
  )
}

resource "google_storage_bucket" "datalake_avro_bucket" {
  name                        = var.datalake_avro_bucket
  location                    = "EU"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "datalake_avro_bucket_object_admin" {
  bucket = google_storage_bucket.datalake_avro_bucket.name
  role   = "roles/storage.objectAdmin"
  member = format("serviceAccount:%s", var.dataflow_worker)
}

# As we use external tables, you need read access to this bucket to read from the BQ tables
resource "google_storage_bucket_iam_binding" "datalake_avro_bucket_viewer_binding" {
  bucket  = google_storage_bucket.datalake_avro_bucket.name
  role    = "roles/storage.objectViewer"
  members = var.data_viewers
}

# ##### Bucket to store the output from the Dataflow job (both unprocessed AND "processed")
resource "google_storage_bucket" "unprocessed_bucket" {
  name                        = var.unprocessed_bucket
  location                    = "EU"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "unprocessed_bucket_object_admin" {
  bucket = google_storage_bucket.unprocessed_bucket.name
  role   = "roles/storage.objectAdmin"
  member = format("serviceAccount:%s", var.dataflow_worker)
}

# As we use external tables, you need read access to this bucket to read from the BQ tables
resource "google_storage_bucket_iam_binding" "unprocessed_bucket_viewer_binding" {
  bucket  = google_storage_bucket.unprocessed_bucket.name
  role    = "roles/storage.objectViewer"
  members = var.data_viewers
}

# ##### The temp bucket is used by the Dataflow job to store intermediate results
resource "google_storage_bucket" "dataflow_temp_bucket" {
  # Prefix the name with the project id as bucket names have to be globally unique
  name                        = var.dataflow_temp_bucket
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "dataflow_temp_bucket_object_admin_binding" {
  bucket = google_storage_bucket.dataflow_temp_bucket.name
  role   = "roles/storage.objectAdmin"
  members = [
    format("serviceAccount:%s", var.dataflow_worker),
    format("serviceAccount:%s", var.application_deployment_svc_account),
  ]
}

#  _____        _                 _
# |  __ \      | |               | |
# | |  | | __ _| |_ __ _ ___  ___| |_
# | |  | |/ _` | __/ _` / __|/ _ \ __|
# | |__| | (_| | || (_| \__ \  __/ |_
# |_____/ \__,_|\__\__,_|___/\___|\__|
resource "google_bigquery_dataset" "datalake_dataset" {
  dataset_id  = var.datalake_dataset
  description = "Raw data from the Trustly data ingestion framework"
  location    = "EU"
}

resource "google_bigquery_dataset_iam_binding" "datalake_dataset_editor_binding" {
  dataset_id = google_bigquery_dataset.datalake_dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  members = [
    format("serviceAccount:%s", var.dataflow_worker),
    format("serviceAccount:%s", var.schema_registry_svc_account),
    format("serviceAccount:%s", var.application_deployment_svc_account),
  ]
}

resource "google_bigquery_dataset_iam_binding" "datalake_dataset_viewer_binding" {
  dataset_id = google_bigquery_dataset.datalake_dataset.dataset_id
  role       = "roles/bigquery.dataViewer"
  members    = var.data_viewers
}


#  _   _      _                      _
# | \ | |    | |                    | |
# |  \| | ___| |___      _____  _ __| | __
# | . ` |/ _ \ __\ \ /\ / / _ \| '__| |/ /
# | |\  |  __/ |_ \ V  V / (_) | |  |   <
# |_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\
resource "google_compute_network" "dataflow_network" {
  name                    = var.network_name
  description             = "VPC network used for hosting Dataflow workers"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dataflow_subnetwork" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnet_cidr_range
  region        = "europe-west1"
  network       = google_compute_network.dataflow_network.id
}

#  _____           _           _                 _ _      _
# |  __ \         (_)         | |               | (_)    (_)
# | |__) | __ ___  _  ___  ___| |_   _ __   ___ | |_  ___ _  ___  ___
# |  ___/ '__/ _ \| |/ _ \/ __| __| | '_ \ / _ \| | |/ __| |/ _ \/ __|
# | |   | | | (_) | |  __/ (__| |_  | |_) | (_) | | | (__| |  __/\__ \
# |_|   |_|  \___/| |\___|\___|\__| | .__/ \___/|_|_|\___|_|\___||___/
#                _/ |               | |
#               |__/                |_|
resource "google_project_iam_member" "dataflow_worker" {
  project = var.project
  role    = "roles/dataflow.worker"
  member  = format("serviceAccount:%s", var.dataflow_worker)
}
