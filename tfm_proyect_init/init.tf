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

module "init_project_module" {
  source = "../modules/project-init"

  gcp_project                 = local.gcp_project
  main_user                   = local.main_user
  terraform_state_bucket_name = local.terraform_state_bucket_name
  svc_terraform_admin_name    = local.svc_terraform_admin_name

  depends_on = [
    google_project.my_project,
  ]
}
