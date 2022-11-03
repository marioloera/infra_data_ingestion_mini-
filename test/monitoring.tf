# For Slack channel data source is used as oposed to resource because teraaform SVT needs to be Slack admin to allow
# intergrations. Only IT team can perform such operation manually. Jira reference IT-5501.

data "google_monitoring_notification_channel" "basic" {
  display_name = "Data Ingestion Framework GCP Alerts"
}

resource "google_monitoring_alert_policy" "dataflow_micro_batch_staging_policy" {
  display_name = "beam-pubsub-avro-gcs-staging micro batch staging error"
  documentation {
    content   = "Dataflow micro batch job beam-pubsub-avro-gcs-staging has errors."
    mime_type = "text/markdown"
  }
  conditions {
    display_name = "Dataflow micro batch Job - logging/user/dataflow_micro_batch_error_staging/metric"
    condition_threshold {
      filter     = "resource.type = \"dataflow_job\" AND metric.type = \"logging.googleapis.com/user/dataflow_micro_batch_error_staging/metric\""
      comparison = "COMPARISON_GT"
      duration   = "0s"
      trigger {
        count = 1
      }
      threshold_value = 0
    }
  }
  combiner              = "OR"
  enabled               = true
  notification_channels = [data.google_monitoring_notification_channel.basic.name]
  depends_on            = [google_logging_metric.dataflow_micro_batch_error_staging_metric]
}


resource "google_monitoring_alert_policy" "dataflow_micro_batch_sysint_policy" {
  display_name = "beam-pubsub-avro-gcs-sysint micro batch sysint error"
  documentation {
    content   = "Dataflow micro batch job beam-pubsub-avro-gcs-sysint has errors."
    mime_type = "text/markdown"
  }
  conditions {
    display_name = "Dataflow micro batch Job - logging/user/dataflow_micro_batch_error_sysint/metric"
    condition_threshold {
      filter     = "resource.type = \"dataflow_job\" AND metric.type = \"logging.googleapis.com/user/dataflow_micro_batch_error_sysint/metric\""
      comparison = "COMPARISON_GT"
      duration   = "0s"
      trigger {
        count = 1
      }
      threshold_value = 0
    }
  }
  combiner              = "OR"
  enabled               = true
  notification_channels = [data.google_monitoring_notification_channel.basic.name]
  depends_on            = [google_logging_metric.dataflow_micro_batch_error_sysint_metric]
}
