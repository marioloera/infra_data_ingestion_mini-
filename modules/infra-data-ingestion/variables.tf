variable "project" {}

variable "topic_name" {
  description = "Name of the Pub/Sub topic to which producers will publish data"
  type        = string
  default     = "phoenix.analytics.avro"
}

variable "subscription_gcs_name" {
  description = "Name of the Pub/Sub subscription to which the Dataflow job (that writes Avro files to GCS) will subscribe"
  type        = string
  default     = "beam-to-gcs"
}

variable "dataflow_worker" {
  description = "'Email' of the Dataflow worker service account"
  type        = string
}

variable "schema_registry_bucket" {
  description = "Name of the bucket that will host all the Avro definition files"
  type        = string
}

variable "schema_registry_svc_account" {
  description = "'Email' of the service account used to deploy schemas and patch tables"
  type        = string
}

variable "application_deployment_svc_account" {
  description = "'Email' of the service account used to deploy the pipeline"
  type        = string
}

variable "datalake_avro_bucket" {
  description = "Name of the bucket to which Avro files will be written"
  type        = string
}

variable "unprocessed_bucket" {
  description = "Name of the bucket to which messages the pipeline fails to process will be written"
  type        = string
}

variable "dataflow_temp_bucket" {
  description = "Name of the bucket used by Dataflow for temporary storage"
  type        = string
}

variable "datalake_dataset" {
  description = "Name of the dataset where the destination tables will be stored"
  type        = string
  default     = "data_lake"
}

variable "subnet_cidr_range" {
  description = "IP/CIDR range for the dataflow worker subnetwork"
  type        = string
  default     = "10.1.0.0/20"
}

variable "pubsub_publishers" {
  description = "Accounts that can publish to the Pub/Sub topic"
  type        = list(string)
  default     = []
}

variable "network_name" {
  description = "Name of the VPC network in which the Dataflow works will be run"
  type        = string
  default     = "dataflow-network"
}

variable "subnetwork_name" {
  description = "Name of the subnetwork in which the Dataflow works will be run"
  type        = string
  default     = "dataflow-subnetwork"
}

variable "data_viewers" {
  description = "Enables user to read the data in the dataset/bucket"
  type        = list(string)
  default     = []
}

variable "schema_viewers" {
  description = "Enables user to read the schemas from the schema registry bucket"
  type        = list(string)
  default     = []
}
