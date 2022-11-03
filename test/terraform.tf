terraform {
  backend "gcs" {
    bucket = "turing-app-367309-terraform-infra"
    prefix = "tft/state"
  }
}
