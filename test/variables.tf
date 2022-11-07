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

variable "_terraform_state_bucket_name_" {
  description = "Name of terraform state bucket"
  type        = string
  default     = "terraform-infra"
}


locals {
  gcp_project = var._gcp_project_
  gcp_region  = "europe-west1"

  terraform_state_bucket_name   = var._terraform_state_bucket_name_
  terraform_state_bucket        = "${var._gcp_project_}-${var._terraform_state_bucket_name_}"
  terraform_state_bucket_prefix = "tft/state"

  svc_terraform_admin_name = var._svc_terraform_admin_name_
  svc_terraform_admin      = "${var._svc_terraform_admin_name_}@${var._gcp_project_}.iam.gserviceaccount.com"
}