variable "_gcp_project_" {
  description = "Name of gcp project"
  type        = string
  default     = "turing-app-367309"
}

variable "_svc_terraform_admin_name_" {
  description = "Name of terraform admin service account"
  type        = string
  default     = "svc-terraform-admin"
}


locals {
  gcp_project = var._gcp_project_
  gcp_region  = "europe-west1"

  terraform_state_bucket_name = "terraform-infra"

  svc_terraform_admin_name = var._svc_terraform_admin_name_
  svc_terraform_admin      = "${var._svc_terraform_admin_name_}@${var._gcp_project_}.iam.gserviceaccount.com"
}
