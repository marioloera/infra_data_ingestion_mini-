terraform {
  backend "gcs" {
    bucket = local.terraform_state_bucket
    prefix = local.terraform_state_bucket_prefix
  }
}
