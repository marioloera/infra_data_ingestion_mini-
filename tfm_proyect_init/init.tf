# to initialize terraform in GCP create a terraform_admin service accout for terrafrom state storage bucket
provider "google" {
  project = local.gcp_project
  region  = local.gcp_region
}

terraform {
  required_version = ">= 1.1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.42.1"
    }

  }

}

# *********************** GCP PROJECT ***********************

resource "google_project" "my_project" {
  name            = local.gcp_project_name # Name of the GCP project ID. Changing this forces a new project to be created.
  project_id      = local.gcp_project
  org_id          = local.organization_id
  billing_account = local.billing_account
}

# data "google_project" "current_project" {
# }

# *********************** SERVICE ACCOUNT ***********************
resource "google_service_account" "svc_terraform_admin" {
  account_id = local.svc_terraform_admin_name
}


# *********************** PROJECT POLICIES ***********************
resource "google_project_iam_member" "svc_terraform_admin_owner" {
  project = local.gcp_project
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.svc_terraform_admin.email}"
}

resource "google_project_iam_binding" "storage_admin" {
  #project = data.google_project.current_project.id
  project = local.gcp_project
  role    = "roles/storage.admin"
  members = [
    "user:${local.main_user}",
    "serviceAccount:${google_service_account.svc_terraform_admin.email}",
  ]
}

# *********************** STORAGE ***********************
resource "google_storage_bucket" "bucket_terraform_infra" {
  name                        = "${local.gcp_project}-${local.terraform_state_bucket_name}"
  project                     = local.gcp_project
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
      "user:${local.main_user}",
      "serviceAccount:${google_service_account.svc_terraform_admin.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bucket_terraform_infra_policy_mapping" {
  bucket      = google_storage_bucket.bucket_terraform_infra.name
  policy_data = data.google_iam_policy.bucket_terraform_infra_policy.policy_data
}
