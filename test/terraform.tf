terraform {
  backend "gcs" {
    # TODO MANUALLY change the bucket
    bucket = "pa-cons-swe-de-2022-mll01-terraform-infra"
    prefix = "tft/state"
  }
}
