# *************************** SINKS ***************************

resource "google_logging_project_sink" "bigquery_data_access_log_sink" {
  name        = "bigquery-data-access-log-sink"
  destination = "bigquery.googleapis.com/projects/trustly-data-services-prod/datasets/bigquery_logs"
  filter      = "resource.type=bigquery_resource AND protoPayload.methodName=jobservice.jobcompleted"

  unique_writer_identity = true
  bigquery_options {
    use_partitioned_tables = true
  }
}


# *************************** METRICS ***************************


resource "google_logging_metric" "dataflow_micro_batch_error_sysint_metric" {
  name   = "dataflow_micro_batch_error_sysint/metric"
  filter = "logName=(\"projects/trustly-data-services-test/logs/dataflow.googleapis.com%2Fworker\" OR \"projects/trustly-data-services-test/logs/dataflow.googleapis.com%2Fjob-message\") severity>=ERROR resource.labels.job_name=\"beam-pubsub-avro-gcs-sysint\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}


resource "google_logging_metric" "dataflow_micro_batch_error_staging_metric" {
  name   = "dataflow_micro_batch_error_staging/metric"
  filter = "logName=(\"projects/trustly-data-services-test/logs/dataflow.googleapis.com%2Fworker\" OR \"projects/trustly-data-services-test/logs/dataflow.googleapis.com%2Fjob-message\") severity>=ERROR resource.labels.job_name=\"beam-pubsub-avro-gcs-staging\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}


resource "google_logging_metric" "avro_gcs_metric" {
  name   = "avro_gcs"
  filter = "resource.labels.step_id=(\"WriteToAvro\") logName=\"projects/trustly-data-services-test/logs/dataflow.googleapis.com%2Fworker\" jsonPayload.message =~ \"Done. Wrote\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "DISTRIBUTION"
    unit        = "1"
    labels {
      key        = "environment"
      value_type = "STRING"
    }
    labels {
      key        = "schema"
      value_type = "STRING"
    }
    labels {
      key        = "fingerprint"
      value_type = "STRING"
    }
    display_name = "Avro records written to GCS"
  }
  value_extractor = "REGEXP_EXTRACT(jsonPayload.message, \"Done\\. Wrote ([0-9]+)\")"
  label_extractors = {
    "environment" = "REGEXP_EXTRACT(labels.\"dataflow.googleapis.com/job_name\", \"([a-z]+)$\")"
    "schema"      = "REGEXP_EXTRACT(jsonPayload.message, \"([a-zA-Z0-9_]+):[0-9-]+$\")"
    "fingerprint" = "REGEXP_EXTRACT(jsonPayload.message, \":([0-9-]+)$\")"
  }
  bucket_options {
    exponential_buckets {
      num_finite_buckets = 64
      growth_factor      = 2
      scale              = 0.01
    }
  }

}
