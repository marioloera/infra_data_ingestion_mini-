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

data "google_project" "current_project" {
}

resource "google_service_account" "svc_terraform_admin" {
  account_id = local.svc_terraform_admin_name
}


resource "google_project_iam_member" "svc_terraform_admin_owner" {
  project = data.google_project.current_project.id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.svc_terraform_admin.email}"
}

resource "google_project_iam_member" "svc_terraform_admin_storage_admin" {
  project = data.google_project.current_project.id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.svc_terraform_admin.email}"
}


module "bucket_terraform_infra" {
  source = "../modules/bucket"

  name = local.terraform_state_bucket_name
  object_admin = [
    # format("serviceAccount:%s", google_service_account.svc_terraform_admin.email),
    "serviceAccount:${google_service_account.svc_terraform_admin.email}",
  ]
}


resource "google_project_service" "cloudresourcemanager_api" {
  service = "cloudresourcemanager.googleapis.com"
}
