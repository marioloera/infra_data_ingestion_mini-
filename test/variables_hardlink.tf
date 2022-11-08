variable "_gcp_project_" {
  description = "Name of gcp project"
  type        = string
  default     = "pa-cons-swe-de-2022-mll02"
}

variable "_svc_terraform_admin_name_" {
  description = "Name of terraform admin service account"
  type        = string
  default     = "svc-terraform-admin"
}


locals {
  main_user = "mario.loera@paconsulting.com" # user who will deploy the first poyect

  organization_id = "133988432162" # PA Consulting
  billing_account = "01D520-0234E5-B62010"

  gcp_project      = var._gcp_project_
  gcp_project_name = var._gcp_project_
  gcp_region       = "europe-west1"

  terraform_state_bucket_name = "terraform-infra"

  svc_terraform_admin_name = var._svc_terraform_admin_name_
  svc_terraform_admin      = "${var._svc_terraform_admin_name_}@${var._gcp_project_}.iam.gserviceaccount.com"
}
