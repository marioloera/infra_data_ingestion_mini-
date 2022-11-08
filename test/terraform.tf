terraform {
  backend "gcs" {
    # TODO MANUALLY change the bucket
    bucket = "pa-cons-swe-de-2022-mll03-terraform-infra"
    prefix = "tft/state"
  }
}
