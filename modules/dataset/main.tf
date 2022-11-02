resource "google_bigquery_dataset" "dataset" {
  dataset_id                      = var.id
  description                     = var.description
  location                        = "EU"
  default_table_expiration_ms     = var.default_table_expiration_ms
  default_partition_expiration_ms = var.default_partition_expiration_ms

  labels = {
    make-sync-bq = var.label_make_sync_bq
  }
}

data "google_project" "current_project" {
}

data "google_iam_policy" "policy" {
  # The primitive project roles are inherited implicitly but there still needs
  # to be at least one explicit owner. The API refuses the update otherwise.
  binding {
    role = "roles/bigquery.dataOwner"
    members = concat(
      [format("serviceAccount:terraform-admin@%s.iam.gserviceaccount.com", data.google_project.current_project.project_id)],
      var.data_owners
    )
  }

  binding {
    role    = "roles/bigquery.dataViewer"
    members = var.data_viewers
  }

  binding {
    role    = "roles/bigquery.dataEditor"
    members = var.data_editors
  }

  # Add further bindings here. Don't forget to add the relevant variable in variables.tf.
  /*binding {
    role    = "roles/bigquery.dataEditor"
    members = var.data_editors
  }*/
}

resource "google_bigquery_dataset_iam_policy" "policy_mapping" {
  dataset_id  = google_bigquery_dataset.dataset.dataset_id
  policy_data = data.google_iam_policy.policy.policy_data
}
