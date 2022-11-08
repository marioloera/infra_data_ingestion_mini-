# data "google_project" "current_project" {
# }

resource "google_storage_bucket" "bucket" {
  # Prefix the name with the project id as bucket names have to be globally unique
  #name                        = format("%s-%s", data.google_project.current_project.project_id, var.name)
  name                        = "${var.gcp_project}-${var.name}"
  location                    = "EU"
  uniform_bucket_level_access = true
  project                     = var.gcp_project


  # The use of a dynamic block here is a bit weird but I can't find a better way to solve it
  dynamic "lifecycle_rule" {
    for_each = [for x in tolist([var.delete_after_days]) : x if x != -1]

    content {
      condition {
        age = lifecycle_rule.value
      }
      action {
        type = "Delete"
      }
    }
  }
}

data "google_iam_policy" "policy" {
  binding {
    role    = "roles/storage.objectAdmin"
    members = var.object_admin
  }

  binding {
    role    = "roles/storage.objectViewer"
    members = var.object_viewer
  }

  binding {
    role    = "roles/storage.admin"
    members = var.storage_admin
  }

  # Add further bindings here. Don't forget to add the relevant variable in variables.tf.
  /*binding {
    role    = "roles/storage.someOtherRole"
    members = var.some_other_storage_role
  }*/

}

resource "google_storage_bucket_iam_policy" "policy_mapping" {
  bucket      = google_storage_bucket.bucket.name
  policy_data = data.google_iam_policy.policy.policy_data
}
