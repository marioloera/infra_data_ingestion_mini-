terraform {
  backend "gcs" {
    bucket = "trustly_infra_data_services_test"
    prefix = "terraform/infra-data-services"
  }
}
