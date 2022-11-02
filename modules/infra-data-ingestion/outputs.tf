output "topic_id" {
  value = google_pubsub_topic.data_ingestion_topic.id
}

output "topic_name" {
  value = google_pubsub_topic.data_ingestion_topic.name
}

output "subscription_avro_gcs_id" {
  value = google_pubsub_subscription.data_ingestion_subscription_avro_gcs.id
}

output "dataset_id" {
  value = google_bigquery_dataset.datalake_dataset.dataset_id
}

output "temp_bucket_name" {
  value = google_storage_bucket.dataflow_temp_bucket.name
}

output "datalake_avro_bucket_name" {
  value = google_storage_bucket.datalake_avro_bucket.name
}

output "unprocessed_bucket_name" {
  value = google_storage_bucket.unprocessed_bucket.name
}

output "schema_registry_bucket_name" {
  value = google_storage_bucket.schema_registry_bucket.name
}
