terraform {
  backend "gcs" {
    bucket = "turing-app-367309-terraform-infra" # TODO MANUALLY
    prefix = "tft/state"
  }
}
