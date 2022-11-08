variable "_gcp_project_" {
  description = "Name of gcp project"
  type        = string
}

variable "_gcp_region_" {
  description = "gcp project"
  type        = string
}

variable "_organization_id_" {
  type = string
}
variable "_billing_account_" {
  type = string
}
variable "_main_user_" {
  type = string
}


variable "_svc_terraform_admin_name_" {
  description = "Name of terraform admin service account"
  type        = string
  default     = "svc-terraform-admin"
}


locals {
  main_user = var._main_user_ # user who will deploy the first poyect

  organization_id = var._organization_id_ # PA Consulting
  billing_account = var._billing_account_

  gcp_project      = var._gcp_project_
  gcp_project_name = var._gcp_project_
  gcp_region       = var._gcp_region_

  terraform_state_bucket_name = "terraform-infra"

  svc_terraform_admin_name = var._svc_terraform_admin_name_
  svc_terraform_admin      = "${var._svc_terraform_admin_name_}@${var._gcp_project_}.iam.gserviceaccount.com"
}
