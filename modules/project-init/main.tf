# data "google_project" "current_project" {
# }

# *********************** SERVICE ACCOUNT ***********************
resource "google_service_account" "svc_terraform_admin" {
  account_id = var.svc_terraform_admin_name
}


# *********************** PROJECT POLICIES ***********************
resource "google_project_iam_member" "svc_terraform_admin_owner" {
  project = var.gcp_project
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.svc_terraform_admin.email}"
}

resource "google_project_iam_binding" "storage_admin" {
  #project = data.google_project.current_project.id
  project = var.gcp_project
  role    = "roles/storage.admin"
  members = [
    "user:${var.main_user}",
    "serviceAccount:${google_service_account.svc_terraform_admin.email}",
  ]
}

# *********************** STORAGE ***********************
resource "google_storage_bucket" "bucket_terraform_infra" {
  name                        = "${var.gcp_project}-${var.terraform_state_bucket_name}"
  project                     = var.gcp_project
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
  requester_pays              = true
  versioning {
    enabled = true
  }

  depends_on = [
    google_project_iam_binding.storage_admin,
  ]
}

data "google_iam_policy" "bucket_terraform_infra_policy" {
  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "user:${var.main_user}",
      "serviceAccount:${google_service_account.svc_terraform_admin.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bucket_terraform_infra_policy_mapping" {
  bucket      = google_storage_bucket.bucket_terraform_infra.name
  policy_data = data.google_iam_policy.bucket_terraform_infra_policy.policy_data
}
