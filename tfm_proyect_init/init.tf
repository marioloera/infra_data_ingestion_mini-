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


# *********************** API ***********************
resource "google_project_service" "cloudresourcemanager_api" {
  service = "cloudresourcemanager.googleapis.com"
}


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
    "serviceAccount:${local.svc_terraform_admin}",
  ]
}

# *********************** STORAGE ***********************
module "bucket_terraform_infra" {
  source = "../modules/bucket"

  name        = local.terraform_state_bucket_name
  gcp_project = local.gcp_project
  object_admin = [
    "user:${local.main_user}",
    "serviceAccount:${google_service_account.svc_terraform_admin.email}",
  ]

  depends_on = [
    google_project_iam_binding.storage_admin,
  ]
}
